# Form config
# ------------------------------------------------------------------
$ElementMargin = 2                            # 0
$FormPadding   = 30                           # 30
$FormWidth     = 150 + (2*$FormPadding)       # 200
$Columns       = 2                            # 2
$RowHeight     = 20+(2*$ElementMargin)        # 25
$ElementBackgroundColor = "Control"           # "Control"
$Wrap          = $True                        # $True

$f = New-Form   -FormPadding $FormPadding `
                -FormWidth $FormWidth `
                -ElementMargin $ElementMargin `
                -Columns $Columns `
                -ElementBackgroundColor $ElementBackgroundColor `
                -Wrap $Wrap `
                -RowHeight $RowHeight

# Elements
# ------------------------------------------------------------------
# Title
$title = New-Element -Name 'l_TITLE'    -Type Label  -Text "New User" -Width $Columns 
$title.Font = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Underline)
#----------------
# Name, Surname
New-Element -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null   
New-Element -Type Label   -Name 'l_Surname' -Text "Surname" | Out-null
New-Element -Type TextBox -Name 't_Name'                    | Out-null
New-Element -Type TextBox -Name 't_Surname'                 | Out-null
#----------------
# Description
New-Element -Type Label   -Name 'l_Description'  -Text "Description" -Width $Columns  | Out-null
New-Element -Type TextBox -Name 't_Description'           -Height 4  -Width $Columns  | Out-null
#----------------
# Notes, submittor
New-Element -Type Label   -Name 'l_Notes'     -Text "Notes"        | Out-null
New-Element -Type Label   -Name 'l_Submittor' -Text "Submitted by" | Out-null
New-Element -Type TextBox -Name 't_Notes'     -Height 3            | Out-null
New-Element -Type TextBox -Name 't_Submittor'                      | Out-null
# Block
New-Element -Type Button  -Name 'b_block' -Text "Block"   | Out-null
#----------------
# Save
New-Element -Type Button  -Name 'b_save' -Text "Save"  -Placement 'OnNewLine'  | Out-null
#----------------

Add-EmptyRow
Add-FormControls

Show-Form 

