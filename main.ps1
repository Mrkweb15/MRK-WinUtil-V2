Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ─── Tab file locations ─────────────────────────────────────────────────────
$tabFiles = [ordered]@{
    "Dashboard" = ".\tabs\Dashboard.ps1"
    "Tweaks"    = ".\tabs\Tweaks.ps1"
    "Cleaner"   = ".\tabs\Cleaner.ps1"
    "Backup"    = ".\tabs\Backup.ps1"
    "Utilities" = ".\tabs\Utilities.ps1"
    "Apps"      = ".\tabs\Apps.ps1"
}

# ─── Local icon paths ─────────────────────────────────────────────────────
$iconPaths = @{
    "Dashboard" = ".\assets\icons\codepen.png"
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

# Original Load-Tab now inlined to avoid external file loading
function Load-Tab {
    param([string]$tabName)

    $mainPanel.Controls.Clear()
    $lblTitle.Text = "Optimizer | $($tabName.ToUpper())"

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

    $mainPanel.Controls.Clear()

    switch ($tabName) {
        "Dashboard" {
            param()

            Add-Type -AssemblyName System.Windows.Forms
            Add-Type -AssemblyName System.Drawing
            
            # ─── Root Panel ───────────────────────────────────────
            $panel = New-Object System.Windows.Forms.Panel
            $panel.Dock = 'Fill'
            $panel.BackColor = [System.Drawing.Color]::FromArgb(17, 24, 39)
            $panel.AutoScroll = $true
            
            # ─── Card Generator ───────────────────────────────────
            function Create-Card {
                param (
                    [string]$title,
                    [string]$description,
                    [string]$label1,
                    [string]$value1,
                    [string]$label2,
                    [string]$value2,
                    [System.Drawing.Point]$location,
                    [string]$iconPath,
                    [System.Drawing.Color]$iconBg
                )
            
                $card = New-Object System.Windows.Forms.Panel
                $card.Size = [System.Drawing.Size]::new(285, 160)
                $card.Location = $location
                $card.BackColor = [System.Drawing.Color]::FromArgb(31, 41, 55)
            
                # Rounded card corners
                $radius = 12
                $path = New-Object System.Drawing.Drawing2D.GraphicsPath
                $path.AddArc(0, 0, $radius, $radius, 180, 90)
                $path.AddArc($card.Width - $radius - 1, 0, $radius, $radius, 270, 90)
                $path.AddArc($card.Width - $radius - 1, $card.Height - $radius - 1, $radius, $radius, 0, 90)
                $path.AddArc(0, $card.Height - $radius - 1, $radius, $radius, 90, 90)
                $path.CloseAllFigures()
                $card.Region = New-Object System.Drawing.Region($path)
            
                # Icon background
                $iconBox = New-Object System.Windows.Forms.Panel
                $iconBox.Size = [System.Drawing.Size]::new(38, 38)
                $iconBox.Location = [System.Drawing.Point]::new(15, 15)
                $iconBox.BackColor = $iconBg
            
                $iconRounded = New-Object System.Drawing.Drawing2D.GraphicsPath
                $iconRounded.AddArc(0, 0, 10, 10, 180, 90)
                $iconRounded.AddArc(28, 0, 10, 10, 270, 90)
                $iconRounded.AddArc(28, 28, 10, 10, 0, 90)
                $iconRounded.AddArc(0, 28, 10, 10, 90, 90)
                $iconRounded.CloseAllFigures()
                $iconBox.Region = New-Object System.Drawing.Region($iconRounded)
            
                if (Test-Path $iconPath) {
                    $img = [System.Drawing.Image]::FromFile($iconPath)
                    $pic = New-Object System.Windows.Forms.PictureBox
                    $pic.Image = $img.GetThumbnailImage(20, 20, $null, [IntPtr]::Zero)
                    $pic.Size = [System.Drawing.Size]::new(20, 20)
                    $pic.Location = [System.Drawing.Point]::new(9, 9)
                    $pic.SizeMode = 'Zoom'
                    $iconBox.Controls.Add($pic)
                }
            
                $lblTitle = New-Object System.Windows.Forms.Label
                $lblTitle.Text = $title
                $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
                $lblTitle.ForeColor = [System.Drawing.Color]::White
                $lblTitle.Location = [System.Drawing.Point]::new(60, 15)
                $lblTitle.AutoSize = $true
            
                $lblDesc = New-Object System.Windows.Forms.Label
                $lblDesc.Text = $description
                $lblDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $lblDesc.ForeColor = [System.Drawing.Color]::LightGray
                $lblDesc.Location = [System.Drawing.Point]::new(60, 35)
                $lblDesc.AutoSize = $true
            
                $lbl1 = New-Object System.Windows.Forms.Label
                $lbl1.Text = $label1
                $lbl1.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $lbl1.ForeColor = [System.Drawing.Color]::LightGray
                $lbl1.Location = [System.Drawing.Point]::new(15, 75)
                $lbl1.AutoSize = $true
            
                $val1 = New-Object System.Windows.Forms.Label
                $val1.Text = $value1
                $val1.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                $val1.ForeColor = [System.Drawing.Color]::White
                $val1.Location = [System.Drawing.Point]::new(15, 90)
                $val1.AutoSize = $true
            
                $lbl2 = New-Object System.Windows.Forms.Label
                $lbl2.Text = $label2
                $lbl2.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $lbl2.ForeColor = [System.Drawing.Color]::LightGray
                $lbl2.Location = [System.Drawing.Point]::new(15, 115)
                $lbl2.AutoSize = $true
            
                $val2 = New-Object System.Windows.Forms.Label
                $val2.Text = $value2
                $val2.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                $val2.ForeColor = [System.Drawing.Color]::White
                $val2.Location = [System.Drawing.Point]::new(15, 130)
                $val2.AutoSize = $true
            
                $card.Controls.AddRange(@($iconBox, $lblTitle, $lblDesc, $lbl1, $val1, $lbl2, $val2))
                return $card
            }
            
            # Gather Actual PC Info
            $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
            $gpu = Get-CimInstance Win32_VideoController | Where-Object { $_.VideoProcessor } | Select-Object -First 1
            $os = Get-CimInstance Win32_OperatingSystem
            $ram = [Math]::Round($os.TotalVisibleMemorySize / 1MB, 2)  # In GB
            $ramType = (Get-CimInstance Win32_PhysicalMemory | Select-Object -First 1).MemoryType
            $ramTypeText = switch ($ramType) {
                20 { "DDR" }
                21 { "DDR2" }
                22 { "DDR2 FB-DIMM" }
                24 { "DDR3" }
                26 { "DDR4" }
                34 { "DDR5" }
                default { "Unknown" }
            }
            
            $disk = Get-CimInstance Win32_DiskDrive | Where-Object { $_.InterfaceType -ne $null } | Select-Object -First 1
            $diskSize = [Math]::Round($disk.Size / 1GB)
            
            # Fallback for GPU if empty
            if (-not $gpu.Name) { $gpu.Name = "Unknown GPU" }
            
            
            # ─── Data ──────────────────────────────────────────────
            $items = @(
                @{ T="CPU"; D="Processor Information"; L1="Model"; V1=$cpu.Name; L2="Cores"; V2="$($cpu.NumberOfCores + $cpu.NumberOfLogicalProcessors - $cpu.NumberOfCores) Threads"; I="cpu.png"; C=[System.Drawing.Color]::FromArgb(59,130,246) },
                @{ T="GPU"; D="Graphics Information"; L1="Model"; V1=$gpu.Name; L2="VRAM"; V2="$([math]::Round($gpu.AdapterRAM / 1GB, 1)) GB"; I="gpu.png"; C=[System.Drawing.Color]::FromArgb(34,197,94) },
                @{ T="Memory"; D="RAM Information"; L1="Total Memory"; V1="$ram GB"; L2="Type"; V2=$ramTypeText; I="memory.png"; C=[System.Drawing.Color]::FromArgb(139,92,246) },
                @{ T="System"; D="OS Information"; L1="Operating System"; V1=$os.Caption; L2="Version"; V2=$os.Version; I="system.png"; C=[System.Drawing.Color]::FromArgb(248,113,113) },
                @{ T="Storage"; D="Disk Information"; L1="Primary Disk"; V1=$disk.Model; L2="Total Space"; V2="$diskSize GB"; I="storage.png"; C=[System.Drawing.Color]::FromArgb(249,115,22) },
                @{ T="Optimizations"; D="System Tweaks Status"; L1="Available Optimizations"; V1="20 Optimizations"; L2="Active Optimizations"; V2="0 Active"; I="optimizations.png"; C=[System.Drawing.Color]::FromArgb(234,179,8) }
            )
            
            
            $cardWidth = 285
            $cardHeight = 160
            $gap = 10
            $startX = 15
            $startY = 15
            $cols = 3
            
            $lastY = 0
            
            for ($i = 0; $i -lt $items.Count; $i++) {
                $col = $i % $cols
                $row = [math]::Floor($i / $cols)
                $x = $startX + ($col * ($cardWidth + $gap))
                $y = $startY + ($row * ($cardHeight + $gap))
                $lastY = $y
            
                $d = $items[$i]
                $iconPath = ".\assets\icons\dashboard\" + $d.I
            
                $card = Create-Card -title $d.T -description $d.D -label1 $d.L1 -value1 $d.V1 -label2 $d.L2 -value2 $d.V2 -location ([System.Drawing.Point]::new($x, $y)) -iconPath $iconPath -iconBg $d.C
                $panel.Controls.Add($card)
            }
            
            # ─── Footer ───────────────────────────────────────────
            $footerY = $lastY + $cardHeight + 40
            $footer = New-Object System.Windows.Forms.Panel
            $footer.Size = [System.Drawing.Size]::new(874, 60)
            $footer.Location = [System.Drawing.Point]::new(15, $footerY)
            $footer.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 60)
            
            $footerIcon = New-Object System.Windows.Forms.PictureBox
            $footerIcon.Size = [System.Drawing.Size]::new(22, 22)
            $footerIcon.Location = [System.Drawing.Point]::new(15, 19)
            $footerIcon.Image = [System.Drawing.Image]::FromFile(".\assets\icons\dashboard\optimizations.png")
            $footerIcon.SizeMode = 'Zoom'
            
            $footerText1 = New-Object System.Windows.Forms.Label
            $footerText1.Text = "PC Running slow?"
            $footerText1.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
            $footerText1.ForeColor = [System.Drawing.Color]::White
            $footerText1.Location = [System.Drawing.Point]::new(45, 12)
            $footerText1.AutoSize = $true
            
            $footerText2 = New-Object System.Windows.Forms.Label
            $footerText2.Text = "Try Using Tweaks to improve system performance"
            $footerText2.Font = New-Object System.Drawing.Font("Segoe UI", 8)
            $footerText2.ForeColor = [System.Drawing.Color]::LightGray
            $footerText2.Location = [System.Drawing.Point]::new(45, 30)
            $footerText2.AutoSize = $true
            
            $footerBtn = New-Object System.Windows.Forms.Button
            $footerBtn.Text = "⚡ Tweaks"
            $footerBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
            $footerBtn.ForeColor = [System.Drawing.Color]::White
            $footerBtn.BackColor = [System.Drawing.Color]::FromArgb(30, 64, 175)
            $footerBtn.Size = [System.Drawing.Size]::new(90, 30)
            $footerBtn.Location = [System.Drawing.Point]::new(750, 15)
            $footerBtn.FlatStyle = 'Flat'
            $footerBtn.FlatAppearance.BorderSize = 0
            $footerBtn.Add_Click({ Load-Tab "Tweaks" })
            
            $footer.Controls.AddRange(@($footerIcon, $footerText1, $footerText2, $footerBtn))
            $panel.Controls.Add($footer)
            
            # Return the panel
            return $panel

        }
        "Tweaks" {
            $tweakPanel = New-Object System.Windows.Forms.Panel
            $tweakPanel.Dock = 'Fill'
            $tweakPanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 40)

            $label = New-Object System.Windows.Forms.Label
            $label.Text = "TWEAKS CONTENT HERE"
            $label.ForeColor = [System.Drawing.Color]::White
            $label.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $label.AutoSize = $true
            $label.Location = [System.Drawing.Point]::new(50, 50)
            $tweakPanel.Controls.Add($label)
            $mainPanel.Controls.Add($tweakPanel)
        }
        "Cleaner" {
            $cleanerPanel = New-Object System.Windows.Forms.Panel
            $cleanerPanel.Dock = 'Fill'
            $cleanerPanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 50)

            $label = New-Object System.Windows.Forms.Label
            $label.Text = "CLEANER CONTENT HERE"
            $label.ForeColor = [System.Drawing.Color]::White
            $label.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $label.AutoSize = $true
            $label.Location = [System.Drawing.Point]::new(50, 50)
            $cleanerPanel.Controls.Add($label)
            $mainPanel.Controls.Add($cleanerPanel)
        }
        "Backup" {
            $backupPanel = New-Object System.Windows.Forms.Panel
            $backupPanel.Dock = 'Fill'
            $backupPanel.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 45)

            $label = New-Object System.Windows.Forms.Label
            $label.Text = "BACKUP CONTENT HERE"
            $label.ForeColor = [System.Drawing.Color]::White
            $label.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $label.AutoSize = $true
            $label.Location = [System.Drawing.Point]::new(50, 50)
            $backupPanel.Controls.Add($label)
            $mainPanel.Controls.Add($backupPanel)
        }
        "Utilities" {
            $utilitiesPanel = New-Object System.Windows.Forms.Panel
            $utilitiesPanel.Dock = 'Fill'
            $utilitiesPanel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 50)

            $label = New-Object System.Windows.Forms.Label
            $label.Text = "UTILITIES CONTENT HERE"
            $label.ForeColor = [System.Drawing.Color]::White
            $label.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $label.AutoSize = $true
            $label.Location = [System.Drawing.Point]::new(50, 50)
            $utilitiesPanel.Controls.Add($label)
            $mainPanel.Controls.Add($utilitiesPanel)
        }
        "Apps" {
            $appsPanel = New-Object System.Windows.Forms.Panel
            $appsPanel.Dock = 'Fill'
            $appsPanel.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 55)

            $label = New-Object System.Windows.Forms.Label
            $label.Text = "APPS CONTENT HERE"
            $label.ForeColor = [System.Drawing.Color]::White
            $label.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $label.AutoSize = $true
            $label.Location = [System.Drawing.Point]::new(50, 50)
            $appsPanel.Controls.Add($label)
            $mainPanel.Controls.Add($appsPanel)
        }
        default {
            $defaultPanel = New-Object System.Windows.Forms.Panel
            $defaultPanel.Dock = 'Fill'
            $defaultPanel.BackColor = [System.Drawing.Color]::Red
            $mainPanel.Controls.Add($defaultPanel)
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
