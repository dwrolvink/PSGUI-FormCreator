$Form               = New-Object  System.Windows.Forms.Form
$Form.Size          = New-Object  System.Drawing.Size(275,460)
$Form.StartPosition = "CenterScreen"


$l_TITLE = New-Object  System.Windows.Forms.Label
$l_TITLE.Text      = "New User"
$l_TITLE.Top       = 32
$l_TITLE.Left      = 32
$l_TITLE.Width     = 196
$l_TITLE.Height    = 20
$l_TITLE.Margin    = 0
$l_TITLE.Padding   = 0
$l_TITLE.BackColor = "Control"
$l_TITLE.TextAlign = "BottomLeft"
$Form.Controls.Add($l_TITLE)

$l_Name = New-Object  System.Windows.Forms.Label
$l_Name.Text      = "Name"
$l_Name.Top       = 56
$l_Name.Left      = 32
$l_Name.Width     = 96
$l_Name.Height    = 20
$l_Name.Margin    = 0
$l_Name.Padding   = 0
$l_Name.BackColor = "Control"
$l_Name.TextAlign = "BottomLeft"
$Form.Controls.Add($l_Name)

$t_Name = New-Object  System.Windows.Forms.TextBox
$t_Name.Text      = ""
$t_Name.Top       = 80
$t_Name.Left      = 32
$t_Name.Width     = 96
$t_Name.Height    = 20
$t_Name.Margin    = 0
$t_Name.Padding   = 10
$t_Name.BackColor = "White"
$t_Name.TextAlign = "Left"
$t_Name.Multiline = $False
$Form.Controls.Add($t_Name)

$l_Surname = New-Object  System.Windows.Forms.Label
$l_Surname.Text      = "Surname"
$l_Surname.Top       = 56
$l_Surname.Left      = 132
$l_Surname.Width     = 96
$l_Surname.Height    = 20
$l_Surname.Margin    = 0
$l_Surname.Padding   = 0
$l_Surname.BackColor = "Control"
$l_Surname.TextAlign = "BottomLeft"
$Form.Controls.Add($l_Surname)

$t_Surname = New-Object  System.Windows.Forms.TextBox
$t_Surname.Text      = ""
$t_Surname.Top       = 80
$t_Surname.Left      = 132
$t_Surname.Width     = 96
$t_Surname.Height    = 20
$t_Surname.Margin    = 0
$t_Surname.Padding   = 10
$t_Surname.BackColor = "White"
$t_Surname.TextAlign = "Left"
$t_Surname.Multiline = $False
$Form.Controls.Add($t_Surname)

$l_Description = New-Object  System.Windows.Forms.Label
$l_Description.Text      = "yeet"
$l_Description.Top       = 104
$l_Description.Left      = 32
$l_Description.Width     = 196
$l_Description.Height    = 20
$l_Description.Margin    = 0
$l_Description.Padding   = 0
$l_Description.BackColor = "Control"
$l_Description.TextAlign = "BottomLeft"
$Form.Controls.Add($l_Description)

$t_Description = New-Object  System.Windows.Forms.TextBox
$t_Description.Text      = ""
$t_Description.Top       = 128
$t_Description.Left      = 32
$t_Description.Width     = 196
$t_Description.Height    = 92
$t_Description.Margin    = 0
$t_Description.Padding   = 10
$t_Description.BackColor = "White"
$t_Description.TextAlign = "Left"
$t_Description.Multiline = $True
$Form.Controls.Add($t_Description)

$l_Notes = New-Object  System.Windows.Forms.Label
$l_Notes.Text      = "Notes"
$l_Notes.Top       = 224
$l_Notes.Left      = 32
$l_Notes.Width     = 96
$l_Notes.Height    = 20
$l_Notes.Margin    = 0
$l_Notes.Padding   = 0
$l_Notes.BackColor = "Control"
$l_Notes.TextAlign = "BottomLeft"
$Form.Controls.Add($l_Notes)

$l_Submittor = New-Object  System.Windows.Forms.Label
$l_Submittor.Text      = "Submitted by"
$l_Submittor.Top       = 224
$l_Submittor.Left      = 132
$l_Submittor.Width     = 96
$l_Submittor.Height    = 20
$l_Submittor.Margin    = 0
$l_Submittor.Padding   = 0
$l_Submittor.BackColor = "Control"
$l_Submittor.TextAlign = "BottomLeft"
$Form.Controls.Add($l_Submittor)

$t_Notes = New-Object  System.Windows.Forms.TextBox
$t_Notes.Text      = ""
$t_Notes.Top       = 248
$t_Notes.Left      = 32
$t_Notes.Width     = 96
$t_Notes.Height    = 68
$t_Notes.Margin    = 0
$t_Notes.Padding   = 10
$t_Notes.BackColor = "White"
$t_Notes.TextAlign = "Left"
$t_Notes.Multiline = $True
$Form.Controls.Add($t_Notes)

$t_Submittor = New-Object  System.Windows.Forms.TextBox
$t_Submittor.Text      = ""
$t_Submittor.Top       = 248
$t_Submittor.Left      = 132
$t_Submittor.Width     = 96
$t_Submittor.Height    = 20
$t_Submittor.Margin    = 0
$t_Submittor.Padding   = 10
$t_Submittor.BackColor = "White"
$t_Submittor.TextAlign = "Left"
$t_Submittor.Multiline = $False
$Form.Controls.Add($t_Submittor)

$b_block = New-Object  System.Windows.Forms.Button
$b_block.Text      = "Block"
$b_block.Top       = 272
$b_block.Left      = 132
$b_block.Width     = 96
$b_block.Height    = 20
$b_block.Margin    = 0
$b_block.Padding   = 1
$b_block.BackColor = "Control"
$b_block.TextAlign = "MiddleCenter"
$Form.Controls.Add($b_block)

$b_save = New-Object  System.Windows.Forms.Button
$b_save.Text      = "Save"
$b_save.Top       = 320
$b_save.Left      = 32
$b_save.Width     = 96
$b_save.Height    = 20
$b_save.Margin    = 0
$b_save.Padding   = 1
$b_save.BackColor = "Control"
$b_save.TextAlign = "MiddleCenter"
$Form.Controls.Add($b_save)

$e = New-Object  System.Windows.Forms.Label
$e.Text      = ""
$e.Top       = 344
$e.Left      = 32
$e.Width     = 196
$e.Height    = 20
$e.Margin    = 0
$e.Padding   = 0
$e.BackColor = "Control"
$e.TextAlign = "TopLeft"
$Form.Controls.Add($e)

$submit = New-Object  System.Windows.Forms.Button
$submit.Text      = "Submit"
$submit.Top       = 368
$submit.Left      = 32
$submit.Width     = 96
$submit.Height    = 20
$submit.Margin    = 0
$submit.Padding   = 1
$submit.BackColor = "Control"
$submit.TextAlign = "MiddleCenter"
$Form.Controls.Add($submit)

$submit = New-Object  System.Windows.Forms.Button
$submit.Text      = "Cancel"
$submit.Top       = 368
$submit.Left      = 132
$submit.Width     = 96
$submit.Height    = 20
$submit.Margin    = 0
$submit.Padding   = 1
$submit.BackColor = "Control"
$submit.TextAlign = "MiddleCenter"
$Form.Controls.Add($submit)

$Form.ShowDialog()