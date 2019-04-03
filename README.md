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

## Placement of elements
The idea for placement is based on how you write text. There's a cursor that you can scroll from left to right, 
and when it reaches the end of the page, it does CRLF (carriage return; line feed) so you scroll one line down, and go back 
to the left.

Scrolling happens per cell. A form is given a width, a number of columns, and a rowheight, and with that you can calculate the cellwidth and cellheight. When you scroll right, you update the $form.CurrentColumn (+1) and $form.CurrentLeft (+cellwidth) (which together make the 'Cursor').

When you create an element, it will be created at the $form.CurrentTop and $form.CurrentLeft, and fill the entire cell, or span multiple cells if `-Height` and/or `-Width` are set (down and to the right).

All of the above will be done automatically by the GUI class, but when you understand the mechanics, you can use the 'helper'
functions like $form.CRLF(n) to tweak the `.psm1` functions, or even directly in your scripts when you're defining the elements!

The basis though is that everything will be done via the module cmdlets (in the .psm1), and that the object methods are not 
used. The idea is to fill up each cell, from left to right, top to bottom, and that the order in which you define elements 
is tied to that order. Any empty spaces should be filled with EmptySpace elements:
```powershell
New-Element -Type 'EmptySpace' -Name 'MaybeIshouldmakeNameNotRequired_ImNotSure' -Width 2
```

## Demo script
[See here for a demonstration](Examples/Example_v2.ps1)

## Further development
The thing I hate most now is that for a script with two columns, I have to define two labels, and then two textboxes, instead of defining the label with the textbox:
```powershell
New-Element -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null   
New-Element -Type Label   -Name 'l_Surname' -Text "Surname" | Out-null

New-Element -Type TextBox -Name 't_Name'                    | Out-null
New-Element -Type TextBox -Name 't_Surname'                 | Out-null
```
I'll be thinking about creating a group, which will then be placed as a single element in the grid.
Something along these lines:
```powershell
New-Element -Group Name                 -Type Label   -Name 'l_Name'    -Text "Name"    | Out-null 
New-Element -Group Name -PlaceGroup     -Type TextBox -Name 't_Name'                    | Out-null

New-Element -Group Name                 -Type Label   -Name 'l_Surname' -Text "Surname" | Out-null
New-Element -Group Surname -PlaceGroup  -Type TextBox -Name 't_Surname'                 | Out-null
```

## Installation
1. Pick a path from your `$env:PSModulePath`
2. Clone this repo to that path
3. Change the name of the folder to 'FormCreator' 
4. Start powershell, and type `Import-Module FormCreator` (to test -no errors is good-; it should already be loaded)
