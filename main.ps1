Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ─── Tab file locations ─────────────────────────────────────────────────────
$tabFiles = [ordered]@{
    "Dashboard" = "https://raw.githubusercontent.com/Mrkweb15/MRK-WinUtil-V2/refs/heads/main/tabs/Dashboard.ps1"
    "Tweaks"    = ".\tabs\Tweaks.ps1"
    "Cleaner"   = ".\tabs\Cleaner.ps1"
    "Backup"    = ".\tabs\Backup.ps1"
    "Utilities" = ".\tabs\Utilities.ps1"
    "Apps"      = ".\tabs\Apps.ps1"
}

# ─── Local icon paths ─────────────────────────────────────────────────────
$iconPaths = @{
    "Dashboard" = "https://raw.githubusercontent.com/Mrkweb15/MRK-WinUtil-V2/refs/heads/main/assets/icons/codepen.png"
    "Tweaks"    = ".\assets\icons\tweaks.png"
    "Cleaner"   = ".\assets\icons\cleaner.png"
    "Backup"    = ".\assets\icons\backup.png"
    "Utilities" = ".\assets\icons\utilities.png"
    "Apps"      = ".\assets\icons\apps.png"
    "Settings"  = ".\assets\icons\settings.png"
}

# ─── Global reference to active button ─────────────────────────────────────────────────────
$global:activeNavButton = $null

function Set-ActiveNavButton {
    param($button)

    foreach ($ctrl in $sidebar.Controls) {
        if ($ctrl -is [System.Windows.Forms.Button]) {
            $ctrl.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
            $ctrl.ForeColor = [System.Drawing.Color]::FromArgb(226, 232, 240)
        }
    }

    $button.BackColor = [System.Drawing.Color]::FromArgb(60, 90, 140)
    $button.ForeColor = [System.Drawing.Color]::White
    $global:activeNavButton = $button
}

function Load-Tab {
    param([string]$tabName)

    $mainPanel.Controls.Clear()
    $lblTitle.Text = "Optimizer | $($tabName.ToUpper()) | Under Develepment"

    $loadingLabel = New-Object System.Windows.Forms.Label
    $loadingLabel.Text = "Loading $tabName..."
    $loadingLabel.ForeColor = [System.Drawing.Color]::White
    $loadingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $loadingLabel.AutoSize = $true
    $loadingLabel.Left = [int](($mainPanel.Width - 200) / 2)
    $loadingLabel.Top = [int](($mainPanel.Height - 30) / 2)
    $mainPanel.Controls.Add($loadingLabel)
    $mainPanel.Refresh()

    Start-Sleep -Milliseconds 300

    if ($tabFiles[$tabName] -ne $null) {
        $file = $tabFiles[$tabName]
        if (Test-Path $file) {
            try {
                $tabPanel = & $file
                if ($tabPanel -is [System.Windows.Forms.Panel]) {
                    $mainPanel.Controls.Clear()
                    $tabPanel.Dock = 'Fill'
                    $mainPanel.Controls.Add($tabPanel)
                } else {
                    [System.Windows.Forms.MessageBox]::Show("Tab '$tabName' did not return a valid Panel.", "Error", "OK", "Error")
                }
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Error loading tab '$tabName': $_", "Error", "OK", "Error")
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("File not found: $file", "Error", "OK", "Error")
        }
    }
}

# ─── Main Form ─────────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text = "MRK-OPT"
$form.Size = New-Object System.Drawing.Size(1100, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 47)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# ─── Sidebar ─────────────────────────────────────────────────────
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Size = New-Object System.Drawing.Size(180, 700)
$sidebar.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
$form.Controls.Add($sidebar)

# ─── Header ─────────────────────────────────────────────────────
$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(920, 60)
$header.Location = New-Object System.Drawing.Point(180, 0)
$header.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)
$form.Controls.Add($header)

# ─── Header Label ─────────────────────────────────────────────────────
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Optimizer | DASHBOARD | Under Develepment"
$lblTitle.ForeColor = [System.Drawing.Color]::White
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$header.Controls.Add($lblTitle)

# ─── Mode Icon Button ─────────────────────────────────────────────────────
$modeButton = New-Object System.Windows.Forms.Button
$modeButton.Size = New-Object System.Drawing.Size(32, 32)
$modeButton.Location = New-Object System.Drawing.Point(820, 14)
$modeButton.FlatStyle = 'Flat'
$modeButton.FlatAppearance.BorderSize = 0
$modeButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)

# Load mode icon
$modeIconPath = ".\\assets\\icons\\mode.png"
if (Test-Path $modeIconPath) {
    try {
        $img = [System.Drawing.Image]::FromFile($modeIconPath)
        $thumb = $img.GetThumbnailImage(20, 20, $null, [System.IntPtr]::Zero)
        $modeButton.Image = $thumb
    } catch {
        Write-Warning "Could not load mode icon: $_"
    }
}

# Create dropdown menu for mode selection
$modeMenu = New-Object System.Windows.Forms.ContextMenuStrip

foreach ($mode in @("System", "Dark", "Light")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $mode
    $item.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Switched to mode: " + $this.Text.Replace("🌓 ", "")) })
    $modeMenu.Items.Add($item)
}

$modeButton.Add_Click({ $modeMenu.Show($modeButton, 0, $modeButton.Height) })
$header.Controls.Add($modeButton)

# ─── Settings Button ───────────────────────────────────────────────
$settingsButton = New-Object System.Windows.Forms.Button
$settingsButton.Size = [System.Drawing.Size]::new(32, 32)
$settingsButton.Location = [System.Drawing.Point]::new(860, 14)
$settingsButton.FlatStyle = 'Flat'
$settingsButton.FlatAppearance.BorderSize = 0
$settingsButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)

# Load settings icon
$settingsIconPath = $iconPaths["Settings"]
if ($settingsIconPath -and (Test-Path $settingsIconPath)) {
    try {
        $img = [System.Drawing.Image]::FromFile($settingsIconPath)
        $thumb = $img.GetThumbnailImage(20, 20, $null, [System.IntPtr]::Zero)
        $settingsButton.Image = $thumb
    } catch {
        # Silent fail to keep output clean
    }
}

# ─── Settings Context Menu ─────────────────────────────────────────
$settingsMenu = New-Object System.Windows.Forms.ContextMenuStrip

$uploadItem = New-Object System.Windows.Forms.ToolStripMenuItem
$uploadItem.Text = "Upload Tweaks"
$uploadItem.Add_Click({ }) # Placeholder, no message box
$null = $settingsMenu.Items.Add($uploadItem)

$downloadItem = New-Object System.Windows.Forms.ToolStripMenuItem
$downloadItem.Text = "Download Tweaks"
$downloadItem.Add_Click({ }) # Placeholder, no message box
$null = $settingsMenu.Items.Add($downloadItem)

$null = $settingsMenu.Items.Add("-")  # Separator, suppress output

$aboutItem = New-Object System.Windows.Forms.ToolStripMenuItem
$aboutItem.Text = "About"
$aboutItem.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("MRK-OPT by Mr.K`nVersion 1.0", "About")
})
$null = $settingsMenu.Items.Add($aboutItem)

# Show menu on click
$settingsButton.Add_Click({
    $settingsMenu.Show($settingsButton, 0, $settingsButton.Height)
})

# Add to header panel
$header.Controls.Add($settingsButton)



# ─── Main Panel ─────────────────────────────────────────────────────
$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Size = New-Object System.Drawing.Size(920, 640)
$mainPanel.Location = New-Object System.Drawing.Point(180, 60)
$mainPanel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 47)
$form.Controls.Add($mainPanel)

# ─── Sidebar Title ─────────────────────────────────────────────────────
$sidebarTitle = New-Object System.Windows.Forms.Label
$sidebarTitle.Text = "MRK-OPT"
$sidebarTitle.ForeColor = [System.Drawing.Color]::White
$sidebarTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$sidebarTitle.AutoSize = $true
$sidebarTitle.Location = New-Object System.Drawing.Point(20, 20)
$sidebar.Controls.Add($sidebarTitle)

# ─── Sidebar Buttons ─────────────────────────────────────────────────────
$i = 0
foreach ($tabEntry in $tabFiles.GetEnumerator()) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = "     " + $tabEntry.Key
    $btn.ForeColor = [System.Drawing.Color]::FromArgb(226, 232, 240)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderSize = 0
    $btn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)
    $btn.Size = New-Object System.Drawing.Size(180, 40)
    $btn.Location = New-Object System.Drawing.Point(0, (60 + ($i * 45)))
    $btn.Tag = $tabEntry.Key
    $btn.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $btn.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $btn.TextImageRelation = [System.Windows.Forms.TextImageRelation]::ImageBeforeText

    # Load icon
    $iconPath = $iconPaths[$tabEntry.Key]
    if ($iconPath -and (Test-Path $iconPath)) {
        try {
            $img = [System.Drawing.Image]::FromFile($iconPath)
            $thumb = $img.GetThumbnailImage(20, 20, $null, [System.IntPtr]::Zero)
            $btn.Image = $thumb
        } catch {
            Write-Warning "Could not load icon for $($tabEntry.Key): $_"
        }
    }

    $btn.Add_Click({
        Load-Tab $this.Tag
        Set-ActiveNavButton $this
    })

    $sidebar.Controls.Add($btn)
    $i++
}

# ─── Sidebar Footer ─────────────────────────────────────────────────────
$sidebarFooter = New-Object System.Windows.Forms.Panel
$sidebarFooter.Size = New-Object System.Drawing.Size(180, 80)
$sidebarFooter.Location = New-Object System.Drawing.Point(0, ($form.Height - 100))  # Changed from -80 to -100
$sidebarFooter.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
$sidebar.Controls.Add($sidebarFooter)

# GitHub Button
$githubButton = New-Object System.Windows.Forms.Button
$githubButton.Size = New-Object System.Drawing.Size(40, 40)
$githubButton.Location = New-Object System.Drawing.Point(10, 10)
$githubButton.FlatStyle = 'Flat'
$githubButton.FlatAppearance.BorderSize = 0
$githubButton.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
$githubButton.Cursor = [System.Windows.Forms.Cursors]::Hand

# Load GitHub icon
$githubIconPath = ".\assets\icons\github.png"
if (Test-Path $githubIconPath) {
    try {
        $img = [System.Drawing.Image]::FromFile($githubIconPath)
        $thumb = $img.GetThumbnailImage(24, 24, $null, [System.IntPtr]::Zero)
        $githubButton.Image = $thumb
    } catch {
        Write-Warning "Could not load GitHub icon: $_"
        $githubButton.Text = "GitHub"
    }
} else {
    $githubButton.Text = "GitHub"
}

$githubButton.Add_Click({
    Start-Process "https://github.com/Mrkweb15/MRK-WinUtil-V2"
})
$sidebarFooter.Controls.Add($githubButton)

# Creator Label
$creatorLabel = New-Object System.Windows.Forms.Label
$creatorLabel.Text = "Created by Mr.K"
$creatorLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$creatorLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$creatorLabel.AutoSize = $true
$creatorLabel.Location = New-Object System.Drawing.Point(60, 20)
$sidebarFooter.Controls.Add($creatorLabel)

# Version Label
$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "v1.0.0"
$versionLabel.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 7)
$versionLabel.AutoSize = $true
$versionLabel.Location = New-Object System.Drawing.Point(60, 40)
$sidebarFooter.Controls.Add($versionLabel)

# ─── Initial tab load ─────────────────────────────────────────────────────
Load-Tab "Dashboard"
Set-ActiveNavButton ($sidebar.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] -and $_.Tag -eq "Dashboard" })

# ─── Start GUI ─────────────────────────────────────────────────────
[void]$form.ShowDialog()




