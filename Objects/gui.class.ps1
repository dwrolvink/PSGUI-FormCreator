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
                $ElementBackgroundColor  )
    {
        # Set Config
        $this.FormWidth       = $FormWidth
        $this.FormPadding     = $FormPadding
        $this.ElementMargin   = $ElementMargin
        $this.ElementPaddding = $ElementPaddding
        $this.RowHeight       = $RowHeight
        $this.Columns         = $Columns

        $this.ElementBackgroundColor = $ElementBackgroundColor

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
        $this.form               = New-Object  System.Windows.Forms.Form
        $this.form.Size          = New-Object  System.Drawing.Size($FormWidth,600) 
        $this.form.StartPosition = "CenterScreen"
        $this.form.Padding       = 0

    }


    # -------------------------------------------------------------------------------------------------------
    # Create elements
    # -------------------------------------------------------------------------------------------------------

    # Called by New-Element cmdlet
    [System.Windows.Forms.Control]
    NewElement($Name, $Type, $Placement, $Text, $Width, $Height, $Left, $Label)
    {
        $obj = $null

        # Set placement style
        # -----------------------------
        $FindFirstFree = $true
        Switch ( $Placement )
        {
            "Bottom"  { $FindFirstFree = $False }
            default   { $FindFirstFree = $True  }
        }

        # Create object
        # -----------------------------
        Switch( $Type )
        { 
            "Label"      { $obj = New-Object  System.Windows.Forms.Label  }
            "Button"     { $obj = New-Object  System.Windows.Forms.Button }
            "Textbox"    { $obj = New-Object  System.Windows.Forms.TextBox}
            "EmptySpace" { $obj = New-Object  System.Windows.Forms.Label  }
             default     { $obj = New-Object  System.Windows.Forms.Label  }
        }

        # Extend object
        # -----------------------------
        $obj | Add-Member -MemberType NoteProperty -Name Row    -Value 0
        $obj | Add-Member -MemberType NoteProperty -Name Column -Value 0
        $obj | Add-Member -MemberType NoteProperty -Name RowSpan    -Value $Height
        $obj | Add-Member -MemberType NoteProperty -Name ColumnSpan -Value $Width

        # Basic element properties
        # -----------------------------
        $obj.Name      = $Name
        $obj.Text      = $Text
        $obj.Margin    = 0                           # we calculate our own margin, easier to calculate stuff that way
        $obj.Padding   = $this.ElementPaddding
        $obj.BackColor = $this.ElementBackgroundColor

        
        # Dynamic placement of element 
        # -----------------------------
        $Placed = $False

        While(! $Placed) # never give up, never surrender
        {
            # Set location where we want the elements to be created
            # ---------------
            $targetRow = $this.CurrentRow
            $targetColumn = $this.CurrentColumn

            If ($Placement -eq 'Bottom'){
                $targetRow += 1
            }

            # Find a slot
            # ---------------
            # Check if slot is vacant
            If($this.isOccupied($targetRow, $targetColumn, $Width, $Height))
            {
                If ($FindFirstFree)
                {
                    If ($Placement -eq 'OnNewLine'){
                        $this.CRLF(1)
                    }
                    Else {
                        $this.ScrollRight(1)
                    }

                    Continue
                }
                Else
                {
                    Write-Host "Can't place element on ($targetColumn,$targetRow)"
                    Return -1
                }
            }

            # If slot is vacant, but not completely on the left, go down one line
            If ($Placement -eq 'OnNewLine' -and $targetColumn -ne 0)
            {
                $this.CRLF(1)
                continue
            }

            # Place element
            # ---------------
            # Set element location (at current cursor location)
            $obj.Row = $targetRow
            $obj.Column = $targetColumn

            # I want to occupy:
            $this.Occupy($targetRow, $targetColumn, $Width, $Height)

            # Finally, time to move on
            $Placed = $true
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
                
                #$obj.Top  = $this.CurrentTop + (2*$this.ElementMargin) -2
            }
            "TextBox" {
                If ($Height -gt 1){ 
                    $obj.Multiline = $true;
                }
                $obj.Padding = 10
                $obj.BackColor = "White"

                #$obj.Top  = $this.CurrentTop + 2

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

    # -------------------------------------------------------------------------------------------------------
    # Move around the form 
    # -------------------------------------------------------------------------------------------------------

    ScrollRight($Cells)
    {
        # Advance Cursor Right
        $this.CurrentColumn += $Cells

        # If advanced too far, press enter
        If($this.CurrentColumn -gt ($this.Columns-1)){
            $this.CRLF(1)
        }
    }

    MoveCursor($col, $row)
    {
        If ($col -gt ($this.Columns -1)){
            Write-Error "Tried to move to column $col, out of bound" 
            return
        }

        $this.CurrentColumn = $col
        $this.CurrentRow    = $row
    }

    CRLF($Times)
    {
        # "Carriage return"
        $this.CurrentColumn = 0

        # "Line feed"
        For($i=$Times; $i -gt 0; $i--){
            # increment row
            $this.CurrentRow += 1

            # update how many rows we have (might be unused atm)
            If($this.CurrentRow -gt $this.Rows){ $this.Rows = $this.CurrentRow}      
        }
    }


    # -------------------------------------------------------------------------------------------------------
    # Tests 
    # -------------------------------------------------------------------------------------------------------

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

}