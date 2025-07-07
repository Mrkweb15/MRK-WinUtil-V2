# Rewritten version of your GUI PowerShell script to load tab files and icons from GitHub raw URLs

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ─── GitHub Base Raw Path ────────────────────────────────────────────
$githubBase = "https://raw.githubusercontent.com/Mrkweb15/MRK-WinUtil-V2/main"

# ─── Tab file GitHub raw URLs ────────────────────────────────────────
$tabFiles = [ordered]@{
    "Dashboard" = "$githubBase/tabs/Dashboard.ps1"
    "Tweaks"    = "$githubBase/tabs/Tweaks.ps1"
    "Cleaner"   = "$githubBase/tabs/Cleaner.ps1"
    "Backup"    = "$githubBase/tabs/Backup.ps1"
    "Utilities" = "$githubBase/tabs/Utilities.ps1"
    "Apps"      = "$githubBase/tabs/Apps.ps1"
}

# ─── Icon GitHub raw URLs ─────────────────────────────────────────────
$iconPaths = @{
    "Dashboard" = "$githubBase/assets/icons/codepen.png"
    "Tweaks"    = "$githubBase/assets/icons/tweaks.png"
    "Cleaner"   = "$githubBase/assets/icons/cleaner.png"
    "Backup"    = "$githubBase/assets/icons/backup.png"
    "Utilities" = "$githubBase/assets/icons/utilities.png"
    "Apps"      = "$githubBase/assets/icons/apps.png"
    "Settings"  = "$githubBase/assets/icons/settings.png"
    "GitHub"    = "$githubBase/assets/icons/github.png"
    "Mode"      = "$githubBase/assets/icons/mode.png"
}

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

function Load-ImageFromURL {
    param($url)
    try {
        $wc = New-Object System.Net.WebClient
        $stream = $wc.OpenRead($url)
        $img = [System.Drawing.Image]::FromStream($stream)
        $stream.Close()
        return $img.GetThumbnailImage(20, 20, $null, [System.IntPtr]::Zero)
    } catch {
        return $null
    }
}

function Load-Tab {
    param([string]$tabName)

    $mainPanel.Controls.Clear()
    $lblTitle.Text = "Optimizer | $($tabName.ToUpper()) | Under Development"

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

    if ($tabFiles[$tabName]) {
        try {
            $tempFile = New-TemporaryFile
            Invoke-WebRequest -Uri $tabFiles[$tabName] -OutFile $tempFile.FullName
            $tabPanel = . $tempFile.FullName
            Remove-Item $tempFile.FullName -Force

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
    }
}


# ─── Create Main Form ─────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text = "MRK-OPT"
$form.Size = New-Object System.Drawing.Size(1100, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 47)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Size = New-Object System.Drawing.Size(180, 700)
$sidebar.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
$form.Controls.Add($sidebar)

$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(920, 60)
$header.Location = New-Object System.Drawing.Point(180, 0)
$header.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)
$form.Controls.Add($header)

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Optimizer | DASHBOARD | Under Development"
$lblTitle.ForeColor = [System.Drawing.Color]::White
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$header.Controls.Add($lblTitle)

$modeButton = New-Object System.Windows.Forms.Button
$modeButton.Size = New-Object System.Drawing.Size(32, 32)
$modeButton.Location = New-Object System.Drawing.Point(820, 14)
$modeButton.FlatStyle = 'Flat'
$modeButton.FlatAppearance.BorderSize = 0
$modeButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)
$modeButton.Image = Load-ImageFromURL $iconPaths["Mode"]

$modeMenu = New-Object System.Windows.Forms.ContextMenuStrip
foreach ($mode in @("System", "Dark", "Light")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $mode
    $item.Add_Click({ [System.Windows.Forms.MessageBox]::Show("Switched to mode: " + $this.Text) })
    $modeMenu.Items.Add($item)
}
$modeButton.Add_Click({ $modeMenu.Show($modeButton, 0, $modeButton.Height) })
$header.Controls.Add($modeButton)

$settingsButton = New-Object System.Windows.Forms.Button
$settingsButton.Size = [System.Drawing.Size]::new(32, 32)
$settingsButton.Location = [System.Drawing.Point]::new(860, 14)
$settingsButton.FlatStyle = 'Flat'
$settingsButton.FlatAppearance.BorderSize = 0
$settingsButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 60)
$settingsButton.Image = Load-ImageFromURL $iconPaths["Settings"]

$settingsMenu = New-Object System.Windows.Forms.ContextMenuStrip

$uploadItem = New-Object System.Windows.Forms.ToolStripMenuItem
$uploadItem.Text = "Upload Tweaks"
$settingsMenu.Items.Add($uploadItem)

$downloadItem = New-Object System.Windows.Forms.ToolStripMenuItem
$downloadItem.Text = "Download Tweaks"
$settingsMenu.Items.Add($downloadItem)

$settingsMenu.Items.Add("-")

$aboutItem = New-Object System.Windows.Forms.ToolStripMenuItem
$aboutItem.Text = "About"
$aboutItem.Add_Click({ [System.Windows.Forms.MessageBox]::Show("MRK-OPT by Mr.K`nVersion 1.0", "About") })
$settingsMenu.Items.Add($aboutItem)

$settingsButton.Add_Click({ $settingsMenu.Show($settingsButton, 0, $settingsButton.Height) })
$header.Controls.Add($settingsButton)

$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Size = New-Object System.Drawing.Size(920, 640)
$mainPanel.Location = New-Object System.Drawing.Point(180, 60)
$mainPanel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 47)
$form.Controls.Add($mainPanel)

$sidebarTitle = New-Object System.Windows.Forms.Label
$sidebarTitle.Text = "MRK-OPT"
$sidebarTitle.ForeColor = [System.Drawing.Color]::White
$sidebarTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$sidebarTitle.AutoSize = $true
$sidebarTitle.Location = New-Object System.Drawing.Point(20, 20)
$sidebar.Controls.Add($sidebarTitle)

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
    $btn.Image = Load-ImageFromURL $iconPaths[$tabEntry.Key]
    $btn.Add_Click({ Load-Tab $this.Tag; Set-ActiveNavButton $this })
    $sidebar.Controls.Add($btn)
    $i++
}

$sidebarFooter = New-Object System.Windows.Forms.Panel
$sidebarFooter.Size = New-Object System.Drawing.Size(180, 80)
$sidebarFooter.Location = New-Object System.Drawing.Point(0, ($form.Height - 100))
$sidebarFooter.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
$sidebar.Controls.Add($sidebarFooter)

$githubButton = New-Object System.Windows.Forms.Button
$githubButton.Size = New-Object System.Drawing.Size(40, 40)
$githubButton.Location = New-Object System.Drawing.Point(10, 10)
$githubButton.FlatStyle = 'Flat'
$githubButton.FlatAppearance.BorderSize = 0
$githubButton.BackColor = [System.Drawing.Color]::FromArgb(19, 19, 35)
$githubButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$githubButton.Image = Load-ImageFromURL $iconPaths["GitHub"]
$githubButton.Add_Click({ Start-Process "https://github.com/Mrkweb15/MRK-WinUtil-V2" })
$sidebarFooter.Controls.Add($githubButton)

$creatorLabel = New-Object System.Windows.Forms.Label
$creatorLabel.Text = "Created by Mr.K"
$creatorLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$creatorLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$creatorLabel.AutoSize = $true
$creatorLabel.Location = New-Object System.Drawing.Point(60, 20)
$sidebarFooter.Controls.Add($creatorLabel)

$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "v1.0.0"
$versionLabel.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 7)
$versionLabel.AutoSize = $true
$versionLabel.Location = New-Object System.Drawing.Point(60, 40)
$sidebarFooter.Controls.Add($versionLabel)

Load-Tab "Dashboard"
Set-ActiveNavButton ($sidebar.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] -and $_.Tag -eq "Dashboard" })

[void]$form.ShowDialog()
