Class FormCreator
{
    # Config
    #-----------------------------------------------------------
    # The following three values create a grid of cells with a certain height and width:
    # Cell width = (FormWidth - 2*FormPadding) / Columns
    $FormWidth
    $FormPadding
    $FormEffectiveWidth  #Fw-fp

    $Columns
    $Rows

    $ColumnWidth 
    $RowHeight
    
    # When Show-Form is called, the FormHeight will be calculated
    # A static height is not yet possible
    $FormHeight

    # ElementWidth  = CellWidth - 2*ElementMargin
    # ElementHeight = RowHeight - 2*ElementMargin
    $ElementMargin
    $ElementPaddding
    
    # Automatically go to next line if maximum number of elements on current row is reached
    # Turning Wrap off is not tested well
    $Wrap = $true

    # Random
    $ElementBackgroundColor
    
    # State
    #-----------------------------------------------------------
    # Keep track of on which row/column we are:
    $CurrentRow = 0
    $CurrentColumn = 0

    # Cursor: where do we draw the current new element?
    $CurrentTop
    $CurrentLeft

    # Grid: which cells are occupied by elements?
    # lists all the occupied cells as a list of rows: $Column[1] = 1,2,4
    $OccupiedRowsInColumn = @($null)

    # Elements: all the created elements are stored here, and only written to the form in ShowForm
    $Elements # = @()
            
    # The actual Form:
    $form
    

    FormCreator($FormWidth, $FormPadding, 
                $ElementMargin, $ElementPaddding, 
                $RowHeight, 
                $Columns, 
                $ElementBackgroundColor,
                $Wrap                        )
    {
        # Set Config
        $this.FormWidth       = $FormWidth
        $this.FormPadding     = $FormPadding
        $this.ElementMargin   = $ElementMargin
        $this.ElementPaddding = $ElementPaddding
        $this.RowHeight       = $RowHeight
        $this.Columns         = $Columns

        $this.ElementBackgroundColor = $ElementBackgroundColor

        $this.Wrap            = $Wrap

        # Set state
        $this.CurrentRow        = 0
        $this.CurrentColumn     = 0
        $this.Elements = @()

        $this.CurrentTop  = $FormPadding
        $this.CurrentLeft = $FormPadding

        # Update Derrived
        $this.FormEffectiveWidth = $FormWidth - (2*$FormPadding)
        $this.ColumnWidth        = $this.FormEffectiveWidth / $this.Columns
        $this.OccupiedRowsInColumn  =  @($null) * $this.Columns
        
        # Create Form
        $this.form              = New-Object  System.Windows.Forms.Form
        $this.form.Size          = New-Object  System.Drawing.Size($FormWidth,600) 
        $this.form.StartPosition = "CenterScreen"
        $this.form.Padding       = 0

    }

    # Called by New-Element cmdlet
    [System.Windows.Forms.Control]NewElement($Name, $Type, $Placement, $Text, $Width, $Height, $Left, $Label)
    {
        $obj = $null


        # Create object
        # -----------------------------
        Switch( $Type )
        {
            "Label"   { $obj = New-Object  System.Windows.Forms.Label  }

            "Button"  { $obj = New-Object  System.Windows.Forms.Button }

            "Textbox" { $obj = New-Object  System.Windows.Forms.TextBox}

            "EmptySpace" { $obj = New-Object  System.Windows.Forms.Label  }

             default   { $obj = New-Object  System.Windows.Forms.Label }
        }

        # Basic element properties
        # -----------------------------
        $obj.Name      = $Name
        $obj.Text      = $Text
        $obj.Margin    = 0                           # we calculate our own margin, easier to calculate stuff that way
        $obj.Padding   = $this.ElementPaddding
        $obj.BackColor = $this.ElementBackgroundColor
        
        # Width/height is given in number of cols/rows; you need to subtract the margin from the definite size
        $obj.Width     = ($Width  * $this.ColumnWidth) - ($this.ElementMargin * 2)
        $obj.Height    = ($Height * $this.RowHeight)   - ($this.ElementMargin * 2)

        
        # Dynamic placement of element 
        # (find the first vacant slot; where slot is the rectangle of cells needed for the element)
        # -----------------------------
        $Placed = $False

        While(! $Placed) # never give up, never surrender
        {
            # If the current slot is occupied, move one step right, and try again
            # (ScrollRight() will move down a line if the end of the row is reached)
            If($this.isOccupied($this.CurrentRow, $this.CurrentColumn, $Width, $Height))
            {
                $this.ScrollRight(1)
            }

            # If slot is vacant, but not completely on the left, go down one line
            Elseif ($Placement -eq 'OnNewLine' -and $this.CurrentColumn -ne 0)
            {
                $this.CRLF(1)
            }

            # We found our slot, let's place the element, and register the occupation
            Else
            {
                # Set element location (at current cursor location)
                $obj.Top  = $this.CurrentTop  + $this.ElementMargin
                $obj.Left = $this.CurrentLeft + $this.ElementMargin

                # I want to occupy:
                $this.Occupy($this.CurrentRow, $this.CurrentColumn, $Width, $Height)

                # Finally, time to move on
                $Placed = $true
            }

            #Write-host "Row/col" $this.CurrentRow"/"$this.CurrentColumn
        }

        
        # Type specific additions
        # Want to move a label just a tiny bit higher than other elements?
        # Or you want to hardcode the background color of textboxes?
        # Do it here, where it won't be overwritten anymore!
        # -----------------------------
        Switch( $Type )
        {
            "Label"   { 
                $obj.TextAlign = "BottomLeft"
                $obj.Padding = 0;
                
                $obj.Top  = $this.CurrentTop + (2*$this.ElementMargin) -2
            }
            "TextBox" {
                If ($Height -gt 1){ 
                    $obj.Multiline = $true;
                }
                $obj.Padding = 10
                $obj.BackColor = "White"

                $obj.Top  = $this.CurrentTop + 2

            }
            "Button" {
                $obj.Padding = 1
            }
        }

        # Save our object
        # -----------------------------
        $this.Elements += $obj

        Return $obj
    }

    ScrollRight($Cells)
    {
        # Advance Cursor Right
        $this.CurrentLeft += ($Cells * $this.ColumnWidth)
        $this.CurrentColumn += $Cells

        # If advanced too far, press enter
        If($this.Wrap -and $this.CurrentColumn -gt $this.Columns-1){
            $this.CRLF(1)
        }
    }

    [bool]isOccupied($row, $col, $Width=1, $Height=1)
    {
        # Cancel if element is placed outside of form
        If ( ($col + ($Width-1)) -gt $this.Columns)
        {
            Write-host "Width of form exceeded" -ForegroundColor Yellow
            Return $True
        }

        # Check each column of the respective row is listed as occupied
        For ($h=($Height-1); $h -ge 0; $h--)
        {
            For ($w=($Width-1); $w -ge 0; $w--)
            {
                If (($row + $h) -in $this.OccupiedRowsInColumn[$col + $w]){
                    Return $True
                }
            }
        }

        Return $False
    }

    [bool]Occupy($row, $col, $Width, $Height)
    {
        # Cancel if element is placed outside of form
        If ( ($col + ($Width-1)) -gt $this.Columns)
        {
            Write-host "Width of form exceeded" -ForegroundColor Yellow
            Return $False
        }
            
        # Mark occupation
        For ($h=($Height-1); $h -ge 0; $h--)
        {
            For ($w=($Width-1); $w -ge 0; $w--)
            {
                #write-host $h
                $this.OccupiedRowsInColumn[($col + $w)] += ,($row + $h)
            }
        }

        Return $True
    }

    ShowForm()
    {
        # Set definite size
        $this.CalcFormSize()
        $DefiniteFormWidth = ($this.FormWidth)
        $DefiniteFormHeight = ($this.FormHeight)
        $this.form.Size = New-Object System.Drawing.Size($DefiniteFormWidth,$DefiniteFormHeight)

        # Write-host "actual hight: " $this.form.height

        # Add elements to form
        Foreach($Element in $this.Elements)
        {
            $this.form.Controls.Add($Element)
            # write-host "Name: " $Element.Name " Pos (Top/Left): ("$Element.Top","$Element.Left") Size(h/w): ("$Element.Height","$Element.Width") Text: " $Element.Text
        }

        # Display form
        [void] $this.form.ShowDialog()    
    }

    CR()
    {
        $this.CurrentLeft = $this.FormPadding
        $this.CurrentColumn = 0
    }

    LF()
    {
        # increment row
        $this.CurrentRow += 1
        If($this.CurrentRow -gt $this.Rows){ $this.Rows = $this.CurrentRow}     
        
        # scroll one row down            
        $this.CurrentTop += $this.RowHeight   
    }

    CRLF($Times)
    {
        $this.CR()

        For($i=$Times; $i -gt 0; $i--){
            $this.LF()
        }
    }

    CalcFormSize()
    {
        $HighestWidth  = 0
        $HighestHeight = 0

        Foreach ($Element in $this.Elements)
        {
            $Height = $Element.Top + $Element.Height
            $Width  = $Element.Left + $Element.Width

            #Write-host "b" $Element.Name $Element.Top $Element.Height $Height  "highest:" $HighestHeight

            If ($Height -gt $HighestHeight){
                $HighestHeight = $Height
            }

            If ($Width -gt $HighestWidth){
                $HighestWidth = $Width
            }
        }

        $this.FormHeight = $HighestHeight + 40 + $this.ElementMargin + $this.FormPadding # topbar is added height
        $this.FormWidth  = $HighestWidth  + 15 + $this.ElementMargin + $this.FormPadding
    }
}