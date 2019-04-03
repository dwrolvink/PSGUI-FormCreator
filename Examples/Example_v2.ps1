Import-Module FormCreator -force

# ------------------------------------------------------------------
# Form config
# ==================================================================
$ElementMargin = 2                            # 0
$FormPadding   = 30                           # 30
$FormWidth     = 150 + (2*$FormPadding)       # 200
$Columns       = 2                            # 2
$RowHeight     = 20+(2*$ElementMargin)        # 25
$ElementBackgroundColor = "Control"           # "Control"
$Wrap          = $True                        # $True

# ------------------------------------------------------------------
# Create form
# ==================================================================
$f = New-Form   -FormPadding $FormPadding `
                -FormWidth $FormWidth `
                -ElementMargin $ElementMargin `
                -Columns $Columns `
                -ElementBackgroundColor $ElementBackgroundColor `
                -Wrap $Wrap `
                -RowHeight $RowHeight

# ------------------------------------------------------------------
# Add elements
# ==================================================================
<#  
    Elements are added per row, from left to right, like typing text. 
    One element will occupy one cell, unless -Width or -Height are given. 

    -Name and -Type are required

    Once a row is filled up, or exceeded, the Form will auto-
    matically scroll to the next row for the next element. 
    You can set -Wrap (in New-Form) to $False, to disable this behavior, 
    but it's not tested well.
#>

# Title
$title = New-Element -Name 'l_TITLE'    -Type Label  -Text "New User" -Width $Columns 
$title.Font = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Underline)

# Name, Surname
New-Element -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null   
New-Element -Type Label   -Name 'l_Surname' -Text "Surname" | Out-null
New-Element -Type TextBox -Name 't_Name'                    | Out-null
New-Element -Type TextBox -Name 't_Surname'                 | Out-null

Show-Form


<# -------------------------------------------------------------------------------
    If -Height is used, and your element uses the full width of the form, 
    the form will automatically put the next element in the first free cell (searched from l2r, t2b)
#>

# Description
New-Element -Type Label   -Name 'l_Description'  -Text "Description" -Width $Columns  | Out-null
New-Element -Type TextBox -Name 't_Description'           -Height 4  -Width $Columns  | Out-null

# Notes, submittor (tags)
New-Element -Type Label   -Name 'l_Notes'     -Text "Notes"        | Out-null
New-Element -Type Label   -Name 'l_Submittor' -Text "Submitted by" | Out-null

Show-Form 


<# -------------------------------------------------------------------------------
    If -Height is used, and your element does not use the full width of the form, 
    the Form will automatically move the new element from left-right, top-down until it finds an empty slot
#>

# Notes, submittor (textboxes)
New-Element -Type TextBox -Name 't_Notes'     -Height 3            | Out-null
New-Element -Type TextBox -Name 't_Submittor'                      | Out-null

# Block
New-Element -Type Button  -Name 'b_block' -Text "Block"   | Out-null

Show-Form 


<# -------------------------------------------------------------------------------
   You can use -Placement "OnNewLine" to have an element appear on a newline
#>

# Save
New-Element -Type Button  -Name 'b_save' -Text "Save"  -Placement 'OnNewLine'  | Out-null

Show-Form 


<#
   You can also add a blank row, and you can add submit|cancel buttons with the following code:
#>

Add-EmptyRow
Add-FormControls

$f.Elements[5].Text = "yeet"

Show-Form 

