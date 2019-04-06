Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

. (Join-Path $PSScriptRoot 'Objects\gui.class.ps1') 

Function New-Form()
{
    Param(
        $FormWidth=200, 
        $FormPadding=30,
        $ElementMargin=2,
        $ElementPaddding=0,
        $RowHeight=25,
        $Columns=2, 
        $ElementBackgroundColor="Control",
        $Wrap=$true
    )

    # write-host "cols: " $Columns

    $script:FormCreator = [FormCreator]::new($FormWidth,$FormPadding, $ElementMargin, $ElementPaddding, $RowHeight, $Columns, $ElementBackgroundColor, $Wrap)

    # Return pointer to form
    return $script:FormCreator
}

Function Get-Form()
{
    return $script:FormCreator
}

Function New-Element()
{
    param
    (
        [Parameter(Mandatory = $true)]
        $Name, 
        [Parameter(Mandatory = $true)]
        $Type, 
        [Parameter(Mandatory = $false)]
        $Placement="Right", 
        $Text, 
        $Height=1, 
        $Width=1, 
        $Left,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Form,
        $Label
    )

    # If no explicit form is passed, load cached form
    If (! ($Form)){
        If (! ($script:FormCreator)){
            New-Form | Out-Null
        }
        $Form = $script:FormCreator
    }

    # Create element
    Return  $Form.NewElement($Name, $Type, $Placement, $Text, $Width, $Height, $Left, $Label)
}



Function Show-Form()
{
    param($Form)

    # If no explicit form is given, show the cache form
    If (! ($Form)){
        $Form = $script:FormCreator
    }

    # Init
    $DefiniteFormWidth = 0
    $DefiniteFormHeight = 0

    # Add elements to form
    Foreach($Element in $Form.Elements)
    {
        # Set position
        $Element.Top  = $Form.FormPadding  + $Form.ElementMargin + ($Form.RowHeight   * $Element.Row   ) 
        $Element.Left = $Form.FormPadding  + $Form.ElementMargin + ($Form.ColumnWidth * $Element.Column)

        # Width/height is given in number of cols/rows; you need to subtract the margin from the definite size
        $Element.Width     = ($Element.ColumnSpan  * $Form.ColumnWidth) - ($Form.ElementMargin * 2)
        $Element.Height    = ($Element.RowSpan     * $Form.RowHeight  ) - ($Form.ElementMargin * 2)

        # Update formwidth/height
        $RightEdge = $Element.Width + $Element.Left
        If ($RightEdge -gt $DefiniteFormWidth){
            $DefiniteFormWidth = $RightEdge
        }

        $BottomEdge = $Element.Height + $Element.Top
        If ($BottomEdge -gt $DefiniteFormHeight){
            $DefiniteFormHeight = $BottomEdge
        }

        # Save
        $Form.form.Controls.Add($Element)
        #write-host "Name: " $Element.Name " Pos (Top/Left): ("$Element.Top","$Element.Left") Size(h/w): ("$Element.Height","$Element.Width") Text: " $Element.Text
    }

    # Set definite size
    $DefiniteFormWidth  += 15 + $Form.ElementMargin + $Form.FormPadding
    $DefiniteFormHeight += 40 + $Form.ElementMargin + $Form.FormPadding

    $Form.FormWidth  = $DefiniteFormWidth
    $Form.FormHeight = $DefiniteFormHeight

    $Form.form.Size = New-Object System.Drawing.Size($DefiniteFormWidth,$DefiniteFormHeight)

    # Display form
    $Form.form.ShowDialog()   
}

Function Add-FormControls()
{
    param($Form)

    # If no explicit form is given, show the cache form
    If (! ($Form)){
        $Form = $script:FormCreator
    }

    If($Form.CurrentLeft -ne $Form.FormPadding)
    {
        $Form.CRLF(1)
    }
    New-Element -Name submit -Type Button -Text "Submit" -Placement "OnNewLine" | Out-Null
    New-Element -Name cancel -Type Button -Text "Cancel"                        | Out-Null

}

Function Add-EmptyRow()
{
    param($Form)

    # If no explicit form is passed, load cached form
    If (! ($Form)){
        If (! ($script:FormCreator)){
            New-Form | Out-Null
        }
        $Form = $script:FormCreator
    }

    New-Element -Name e -Type EmptySpace -Width $Form.Columns -Placement "OnNewLine" | Out-Null

}

Function Export-Form()
{
    param($Form)

    # If no explicit form is passed, load cached form
    If (! ($Form)){
        If (! ($script:FormCreator)){
            New-Form | Out-Null
        }
        $Form = $script:FormCreator
    }

    # Init
    $code = ""
    $code += '$Form               = New-Object  System.Windows.Forms.Form'+"`n"
    $code += '$Form.Size          = New-Object  System.Drawing.Size('+$Form.FormWidth+','+$Form.FormHeight+')'+"`n"
    $code += '$Form.StartPosition = "CenterScreen"'+"`n"
    $code += "`n"
    
    # Add Elements
    Foreach ($Element in  $Form.Elements)
    {
        $code += "`n"    
        $code += '$'+$Element.Name+' = New-Object  System.Windows.Forms.'+$Element.GetType().Name+"`n"
        $code += '$'+$Element.Name+'.Text      = "'+$Element.Text+'"'+"`n"
        $code += '$'+$Element.Name+'.Top       = '+$Element.Top+"`n"
        $code += '$'+$Element.Name+'.Left      = '+$Element.Left+"`n"
        $code += '$'+$Element.Name+'.Width     = '+$Element.Width+"`n"
        $code += '$'+$Element.Name+'.Height    = '+$Element.Height+"`n"
        $code += '$'+$Element.Name+'.Margin    = 0'+"`n"
        $code += '$'+$Element.Name+'.Padding   = '+$Element.Padding.All+"`n"
        $code += '$'+$Element.Name+'.BackColor = "'+$Element.BackColor.Name+'"'+"`n"
        $code += '$'+$Element.Name+'.TextAlign = "'+$Element.TextAlign+'"'+"`n"
        
        If ($Element.GetType().Name -eq 'TextBox'){
            $code += '$'+$Element.Name+'.Multiline = $'+$Element.Multiline+"`n"
        }


        $code += '$Form.Controls.Add($'+$Element.Name+')'+"`n"
    }
    
    $code += "`n"

    # Print form
    $code += '$Form.ShowDialog()'
    $code += "`n"
    $code += "`n"

    return $code
}



