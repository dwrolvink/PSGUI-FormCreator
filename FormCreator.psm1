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


