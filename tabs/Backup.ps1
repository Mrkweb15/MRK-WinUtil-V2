$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = 'Fill'
$panel.BackColor = [System.Drawing.Color]::FromArgb(37, 37, 55)

# ── Layout Settings ─────────────────────────────
$panelPadding = 20
$cardWidth = 880
$cardHeight = 160
$gapY = 20
$startY = $panelPadding
$cardFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$descFont = New-Object System.Drawing.Font("Segoe UI", 9)
$cardBack = [System.Drawing.Color]::FromArgb(50, 50, 70)
$cardFore = [System.Drawing.Color]::White

# ── Backup Options with Detailed Info ──────────────────────
$backupOptions = @(
    @{
        Title = "System Restore Point"
        Description = "Create a system restore point which allows rolling back Windows settings and system files to a previous working state. Useful before major updates or installs."
        Steps = "1. Click 'Create' to make a restore point with current system config.`n2. If issues occur, click 'Restore' to go back to this state.`n3. Restore Points do not affect personal files."
        CreateAction = { [System.Windows.Forms.MessageBox]::Show("Creating restore point... (System protection must be enabled)") }
        RestoreAction = { [System.Windows.Forms.MessageBox]::Show("Launching system restore wizard...") }
    },
    @{
        Title = "Full OS Backup (to USB)"
        Description = "Create a full image backup of your Windows installation to an external USB drive. Restoring from this image can recover your OS in case of system corruption or disk failure."
        Steps = "1. Connect a USB drive with sufficient space.`n2. Click 'Create' to initiate full system image backup.`n3. To restore, boot using recovery media and click 'Restore'."
        CreateAction = { [System.Windows.Forms.MessageBox]::Show("Starting full system image backup wizard...") }
        RestoreAction = { [System.Windows.Forms.MessageBox]::Show("Please boot to Windows recovery to restore the image.") }
    },
    @{
        Title = "Personal Data Backup (to USB)"
        Description = "Backs up selected folders (Documents, Desktop, Downloads, etc.) to a USB drive. Helps you secure important files before system maintenance or reset."
        Steps = "1. Connect a USB drive.`n2. Click 'Create' to copy personal files.`n3. Use 'Restore' to copy files back to original locations."
        CreateAction = { [System.Windows.Forms.MessageBox]::Show("Starting file backup process...") }
        RestoreAction = { [System.Windows.Forms.MessageBox]::Show("Restoring personal files...") }
    }
)

# ── Render Cards Horizontally ───────────────────────────
for ($i = 0; $i -lt $backupOptions.Count; $i++) {
    $opt = $backupOptions[$i]
    $y = $startY + $i * ($cardHeight + $gapY)

    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size($cardWidth, $cardHeight)
    $card.Location = New-Object System.Drawing.Point(20, $y)
    $card.BackColor = $cardBack
    $card.BorderStyle = 'FixedSingle'

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = $opt.Title
    $title.Font = $cardFont
    $title.ForeColor = $cardFore
    $title.AutoSize = $true
    $title.Location = New-Object System.Drawing.Point(10, 10)
    $card.Controls.Add($title)

    # Description
    $desc = New-Object System.Windows.Forms.Label
    $desc.Text = $opt.Description
    $desc.Font = $descFont
    $desc.ForeColor = $cardFore
    $desc.AutoSize = $true
    $desc.MaximumSize = New-Object System.Drawing.Size(720, 0)
    $desc.Location = New-Object System.Drawing.Point(10, 35)
    $card.Controls.Add($desc)

    # Step-by-step
    $steps = New-Object System.Windows.Forms.Label
    $steps.Text = $opt.Steps
    $steps.Font = $descFont
    $steps.ForeColor = [System.Drawing.Color]::LightGray
    $steps.AutoSize = $true
    $steps.MaximumSize = New-Object System.Drawing.Size(720, 0)
    $steps.Location = New-Object System.Drawing.Point(10, 70)
    $card.Controls.Add($steps)

    # Create Button
    $createBtn = New-Object System.Windows.Forms.Button
    $createBtn.Text = "Create"
    $createBtn.Size = New-Object System.Drawing.Size(80, 30)
    $createBtn.Location = New-Object System.Drawing.Point(770, 35)
    $createBtn.BackColor = [System.Drawing.Color]::FromArgb(60, 140, 90)
    $createBtn.ForeColor = [System.Drawing.Color]::White
    $createBtn.FlatStyle = 'Flat'
    $createBtn.FlatAppearance.BorderSize = 0
    $createBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $createBtn.Add_Click($opt.CreateAction)
    $card.Controls.Add($createBtn)

    # Restore Button
    $restoreBtn = New-Object System.Windows.Forms.Button
    $restoreBtn.Text = "Restore"
    $restoreBtn.Size = New-Object System.Drawing.Size(80, 30)
    $restoreBtn.Location = New-Object System.Drawing.Point(770, 75)
    $restoreBtn.BackColor = [System.Drawing.Color]::FromArgb(180, 120, 60)
    $restoreBtn.ForeColor = [System.Drawing.Color]::White
    $restoreBtn.FlatStyle = 'Flat'
    $restoreBtn.FlatAppearance.BorderSize = 0
    $restoreBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $restoreBtn.Add_Click($opt.RestoreAction)
    $card.Controls.Add($restoreBtn)

    $panel.Controls.Add($card)
}

return $panel
