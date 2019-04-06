Import-Module FormCreator -force

# ------------------------------------------------------------------
# Form config
# ==================================================================
$ElementMargin          = 2                            # 0
$FormPadding            = 30                           # 30
$FormWidth              = 200 + (2*$FormPadding)       # 200
$Columns                = 2                            # 2
$RowHeight              = 20+(2*$ElementMargin)        # 25
$ElementBackgroundColor = "Control"                    # "Control"

# ------------------------------------------------------------------
# Create form
# ==================================================================
$f = New-Form         -FormPadding $FormPadding `
                      -FormWidth $FormWidth `
                      -ElementMargin $ElementMargin `
                      -Columns $Columns `
                      -ElementBackgroundColor $ElementBackgroundColor `
                      -RowHeight $RowHeight

# Title
$title      = New-Element -Type Label -Name 'l_TITLE'  -Text "New User" -Width $Columns 
$title.Font = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Underline)

# Name, Surname (clustered)
New-Element -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null   
New-Element -Type TextBox -Name 't_Name' -Placement Below  | Out-null

New-Element -Type Label   -Name 'l_Surname' -Text "Surname"   | Out-null
New-Element -Type TextBox -Name 't_Surname' -Placement Below | Out-null

# Description
New-Element -Type Label   -Name 'l_Description'  -Text "Description" -Width $Columns  | Out-null
New-Element -Type TextBox -Name 't_Description'           -Height 4  -Width $Columns  | Out-null

# Notes, submittor (labels first)
New-Element -Type Label   -Name 'l_Notes'     -Text "Notes"        | Out-null
New-Element -Type Label   -Name 'l_Submittor' -Text "Submitted by" | Out-null

New-Element -Type TextBox -Name 't_Notes'     -Height 3            | Out-null
New-Element -Type TextBox -Name 't_Submittor'                      | Out-null

# Block & Save
New-Element -Type Button  -Name 'b_block' -Text "Block"   | Out-null
New-Element -Type Button  -Name 'b_save' -Text "Save"  -Placement 'OnNewLine'  | Out-null

# Spacer
Add-EmptyRow

# Submit & Cancel
Add-FormControls

# ------------------------------------------------------------------
# Print & Export 
# ==================================================================
# Print form
Show-Form 
# Export plain Powershell code to clipboard
Export-Form | clip
