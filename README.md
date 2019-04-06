# PSGUI-FormCreator
Create PowerShell forms easily with this handy wrapper!

I created this package because I'm too lazy to manually figure out where each element goes. 
I just want to type in which elements I want and have them be placed logically.

In it's simplest form creating a form will look like:
```powershell
New-Form -Columns 1
New-Element -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null   
New-Element -Type TextBox -Name 't_Name'                    | Out-null
Add-FormControls
Show-Form 
```

But of course a lot more options are available (and necessary).
For example, a pointer to the element is returned, so you can do any manual adjustments you need to make to the raw `[System.Windows.Forms.xxx]` object, so you are never limited to what's already in the module:

```powershell
$title = New-Element -Type Label -Name 'l_Title'  -Text "New User" -Width $Columns 
$title.Font = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Underline)
```

## Demo script
[See here for a demonstration](Examples/Example_v3.ps1)

## Installation
1. Pick a path from your `$env:PSModulePath`
2. Clone this repo to that path
3. Change the name of the folder to 'FormCreator' 
4. Start powershell, and type `Import-Module FormCreator` (to test -no errors is good-; it should already be loaded)


## Placement of elements
### Where elements are created
The idea for placement is based on how you write text. There's a cursor that you can scroll from left to right, 
and when it reaches the end of the page, it does CRLF (carriage return; line feed) so you scroll one line down, and go back 
to the left.

You can also place elements in a different manner. When you add `-Placement Below`, the element will be placed in the cell below the cursor. This is handy for when you have multiple columns, and want to group your labels with your textboxes:
``` powershell
New-Form -Columns 2

# Name
New-Element -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null   
New-Element -Type TextBox -Name 't_Name' -Placement Below   | Out-null

# Surname
New-Element -Type Label   -Name 'l_Surname' -Text "Surname"   | Out-null
New-Element -Type TextBox -Name 't_Surname' -Placement Below  | Out-null
```

If you add `-Placement OnNewLine`, the element will not be placed in the first available cell, but in the first available cell on column 0. 

Note that when using `-Placement Below`, the cell under the cursor has to be empty, otherwise the creation of the element will be canceled.

> The idea here is that choosing to forgo automatic placement means that you have a clear idea where you want your elements to go, and trying to place an element in an occupied cell should be made clear to the user in that case.

### Skipping cells / rows
You can skip a cell by calling `$Form.ScrollRight(1)`, which is currently the simplest solution, or by creating an empty element in the cell: `New-Element -Name e1 -Type EmptySpace -Width 1 | Out-Null`

I'm leaning more to using empty elements for everything, but tbh, it seems bloaty and I'm not sure which route will be better going forward.

One thing is, that the latter method is really flexible. The function `Add-EmptyRow()` for example, creates the following element:
```powershell
New-Element -Name e -Type EmptySpace -Width $Form.Columns -Placement "OnNewLine" | Out-Null
```
The "OnNewLine" skips to the first empty cell on column 0 (where there is also room for the entire element, even if it spans more columns). `-Width $Form.Columns` says: max width.

If you want to get really creative with jumping around, you could also use `$Form.MoveCursor($col, $row)`, to just move to the cell you want to without any fuss.

### Calculating position and size (in px)
In the creation phase, the position of the elements is completely virtual (i.e. only represented by row/column numbers). When Show-Form() is called, the actual position of each element is calculated based on rowheight, columnwidth, elementmargin, formpadding, and formwidth.

Then, you can call `Export-Form()` to generate plain Powershell code to use in your applications, so you don't need to ship this package with your apps! When you have that code, you can start adding functions and breathe some life into your forms.


