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
    New-Element -Name submit -Type Button -Text "Cancel"                        | Out-Null

}

Function Show-Form()
{
    param($Form)

    # If no explicit form is given, show the cache form
    If (! ($Form)){
        $Form = $script:FormCreator
    }
    $Form.ShowForm()
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


    # Form
    $code += '$Form               = New-Object  System.Windows.Forms.Form'+"`n"
    $code += '$Form.Size          = New-Object  System.Drawing.Size('+$Form.FormWidth+','+$Form.FormHeight+')'+"`n"
    $code += '$Form.StartPosition = "CenterScreen"'+"`n"
    $code += "`n"
    

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

    $code += '$Form.ShowDialog()'
    $code += "`n"
    $code += "`n"

    return $code
}



