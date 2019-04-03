# PSGUI-FormCreator
Create PowerShell forms easily with this handy wrapper!

I created this package because I'm too lazy to manually figure out where each element goes. 
I just want to type in which elements I want and have them be placed logically.

At the moment, all this package does is that. But I'm gonna add more functional functionality soon.

The idea for placement is based on how you write text. There's a cursor that you can scroll from left to right, 
and when it reaches the end of the page, it does CRLF (carriage return; line feed) so you scroll one line down, and go back 
to the left.

Scrolling happens per cell. A form is given a width, a number of columns, and a rowheight, and with that you can calculate the
cellwidth and cellheight. When you scroll right, you update the $form.CurrentColumn (+1) and $form.CurrenLeft (+cellwidth).

When you create an element, it will be created at the currentTop and currentLeft, and fill the entire cell, or span multiple cells
(down and to the right).

Most of this will be done by the GUI class, but you can use $form.CRLF(n) in the module for example, and even in your scripts
when you're defining the elements.

[See here for a demonstration](Examples/Example_v2.ps1)
