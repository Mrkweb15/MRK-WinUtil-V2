Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = [System.Drawing.Size]::new(920, 640)
$panel.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 60)

# Footer
$footer = New-Object System.Windows.Forms.Panel
$footer.Size = [System.Drawing.Size]::new(920, 60)
$footer.Location = [System.Drawing.Point]::new(0, 550)
$footer.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 50)
$panel.Controls.Add($footer)

# Content
$contentPanel = New-Object System.Windows.Forms.Panel
$contentPanel.Size = [System.Drawing.Size]::new(920, 550)
$contentPanel.Location = [System.Drawing.Point]::new(0, 0)
$contentPanel.BackColor = $panel.BackColor
$panel.Controls.Add($contentPanel)

# Categories
$systemTools = @{"System Tools" = @("Process Explorer", "Autoruns", "MSI Afterburner", "HWMonitor", "CPU-Z", "GPU-Z", "Revo Uninstaller")}

$categories = @{
    "Package Managers"     = @("Chocolatey", "Scoop", "WingetUI")
    "Debloat & Cleaners"   = @("TronScript", "O&O AppBuster", "BleachBit", "CCleaner")
    "Browsers"             = @("Firefox", "Brave", "LibreWolf", "Edge", "Chrome")
    "Optimizers"           = @("WizTree", "Patch My PC", "Glary Utilities", "Advanced SystemCare")
    "Security & Fixes"     = @("Malwarebytes", "AdwCleaner", "DefenderUI", "MSRT", "FixWin10")
    "Archivers"            = @("7-Zip", "PeaZip", "NanaZip")
    "Image Tools"          = @("IrfanView", "Paint.NET", "ShareX", "XnView")
    "Media Players"        = @("VLC", "MPV", "PotPlayer", "SMPlayer")
    "File Tools"           = @("Everything", "FreeCommander", "Q-Dir", "FastCopy")
    "Editors & Dev Tools"  = @("Notepad++", "Visual Studio Code", "Sublime Text", "WinMerge")
    "Office & PDF"         = @("LibreOffice", "SumatraPDF", "Foxit Reader")
}

$checkboxes = @{}

# Split into 3 columns (excluding system tools)
$sorted = ($categories.GetEnumerator() | Sort-Object Name)
$total = $sorted.Count
$perCol = [Math]::Ceiling($total / 3)

$columns = @(
    $sorted[0..($perCol-1)],
    $sorted[$perCol..(2*$perCol - 1)],
    $sorted[(2*$perCol)..($total-1)]
)

# Layout settings
$colWidth = 210
$startX = 10
$gapX = 10
$font = New-Object System.Drawing.Font("Segoe UI", 10)
$fontBold = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

# Render 3 columns for general categories
for ($col = 0; $col -lt 3; $col++) {
    $columnPanel = New-Object System.Windows.Forms.Panel
    $columnPanel.Size = [System.Drawing.Size]::new($colWidth, 530)
    $columnPanel.Location = [System.Drawing.Point]::new($startX + ($col * ($colWidth + $gapX)), 10)
    $columnPanel.BackColor = $panel.BackColor

    $curY = 0
    foreach ($cat in $columns[$col]) {
        $label = New-Object System.Windows.Forms.Label
        $label.Text = $cat.Key
        $label.ForeColor = [System.Drawing.Color]::White
        $label.Font = $fontBold
        $label.Location = [System.Drawing.Point]::new(5, $curY)
        $label.AutoSize = $true
        $columnPanel.Controls.Add($label)
        $curY += 25

        foreach ($app in $cat.Value) {
            $chk = New-Object System.Windows.Forms.CheckBox
            $chk.Text = $app
            $chk.ForeColor = [System.Drawing.Color]::White
            $chk.Font = $font
            $chk.BackColor = $panel.BackColor
            $chk.Size = [System.Drawing.Size]::new($colWidth - 20, 22)
            $chk.Location = [System.Drawing.Point]::new(10, $curY)
            $columnPanel.Controls.Add($chk)
            $checkboxes[$app] = $chk
            $curY += 24
        }
        $curY += 10
    }
    $contentPanel.Controls.Add($columnPanel)
}

# Render last column just for system tools
$sysPanel = New-Object System.Windows.Forms.Panel
$sysPanel.Size = [System.Drawing.Size]::new($colWidth, 530)
$sysPanel.Location = [System.Drawing.Point]::new($startX + (3 * ($colWidth + $gapX)), 10)
$sysPanel.BackColor = $panel.BackColor

$curY = 0
foreach ($cat in $systemTools.GetEnumerator()) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $cat.Key
    $label.ForeColor = [System.Drawing.Color]::White
    $label.Font = $fontBold
    $label.Location = [System.Drawing.Point]::new(5, $curY)
    $label.AutoSize = $true
    $sysPanel.Controls.Add($label)
    $curY += 25

    foreach ($app in $cat.Value) {
        $chk = New-Object System.Windows.Forms.CheckBox
        $chk.Text = $app
        $chk.ForeColor = [System.Drawing.Color]::White
        $chk.Font = $font
        $chk.BackColor = $panel.BackColor
        $chk.Size = [System.Drawing.Size]::new($colWidth - 20, 22)
        $chk.Location = [System.Drawing.Point]::new(10, $curY)
        $sysPanel.Controls.Add($chk)
        $checkboxes[$app] = $chk
        $curY += 24
    }
}

$contentPanel.Controls.Add($sysPanel)

# Footer buttons
$footerBtns = @(
    @{ Text = "Install/Update"; Color = "60,140,90"; Action = {
        $selected = $checkboxes.GetEnumerator() | Where-Object { $_.Value.Checked }
        foreach ($app in $selected) { Write-Host "Installing/Updating $($app.Key)..." }
    }},
    @{ Text = "Reinstall"; Color = "90,120,180"; Action = {
        $selected = $checkboxes.GetEnumerator() | Where-Object { $_.Value.Checked }
        foreach ($app in $selected) { Write-Host "Reinstalling $($app.Key)..." }
    }},
    @{ Text = "Uninstall"; Color = "180,60,60"; Action = {
        $selected = $checkboxes.GetEnumerator() | Where-Object { $_.Value.Checked }
        foreach ($app in $selected) { Write-Host "Uninstalling $($app.Key)..." }
    }},
    @{ Text = "Clear Data"; Color = "120,90,140"; Action = {
        $selected = $checkboxes.GetEnumerator() | Where-Object { $_.Value.Checked }
        foreach ($app in $selected) { Write-Host "Clearing data for $($app.Key)..." }
    }},
    @{ Text = "Clear Selection"; Color = "100,20,50"; Action = {
        $selected = $checkboxes.GetEnumerator() | Where-Object { $_.Value.Checked }
        foreach ($app in $selected) { Write-Host "Clearing data for $($app.Key)..." }
    }}
)

for ($i = 0; $i -lt $footerBtns.Count; $i++) {
    $b = $footerBtns[$i]
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $b.Text
    $btn.Size = [System.Drawing.Size]::new(110, 30)
    $btn.Location = [System.Drawing.Point]::new(20 + ($i * 140), 10)
    $rgb = $b.Color -split ','
    $btn.BackColor = [System.Drawing.Color]::FromArgb($rgb[0], $rgb[1], $rgb[2])
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = $fontBold
    $btn.Add_Click($b.Action)
    $footer.Controls.Add($btn)
}

return $panel
