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
            Add-Type -AssemblyName System.Windows.Forms
            Add-Type -AssemblyName System.Drawing
            
            $panel = New-Object System.Windows.Forms.Panel
            $panel.Dock = 'Fill'
            $panel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 47)
            $panel.AutoScroll = $true
            
            # Icon paths for each tweak (ensure these exist)
            $iconPaths = @{
                "Create Restore Point"     = "assets/icons/tweaks/restore.png"
                "Clear DNS Cache"          = "assets/icons/tweaks/dns.png"
                "Toggle Search Bar"        = "assets/icons/tweaks/search.png"
                "Toggle Location Tracking" = "assets/icons/tweaks/location.png"
                "Toggle Teredo"            = "assets/icons/tweaks/teredo.png"
                "Toggle Hibernation"       = "assets/icons/tweaks/sleep.png"
                "Performance Display Mode" = "assets/icons/tweaks/performance.png"
            }
            
            # Descriptions for each tweak
            $descriptions = @{
                "Create Restore Point"     = "Create a system restore point before making changes."
                "Clear DNS Cache"          = "Flushes the DNS resolver cache to fix browsing issues."
                "Toggle Search Bar"        = "Show or hide the taskbar search box on Windows."
                "Toggle Location Tracking" = "Enable or disable location tracking by the system."
                "Toggle Teredo"            = "Manage Teredo tunneling used for IPv6 connectivity."
                "Toggle Hibernation"       = "Turn system hibernation on or off."
                "Performance Display Mode" = "Open environment settings to adjust performance."
            }
            
            function New-TweakCard {
                param (
                    [string]$title,
                    [string]$buttonText,
                    [System.Drawing.Point]$location,
                    [ScriptBlock]$onClick,
                    [bool]$isToggle = $false,
                    [string]$iconPath,
                    [string]$description
                )
            
                $card = New-Object System.Windows.Forms.Panel
                $card.Size = New-Object System.Drawing.Size(270, 140)
                $card.Location = $location
                $card.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 65)
            
                # Rounded corners
                $radius = 12
                $path = New-Object System.Drawing.Drawing2D.GraphicsPath
                $path.AddArc(0, 0, $radius, $radius, 180, 90)
                $path.AddArc($card.Width - $radius, 0, $radius, $radius, 270, 90)
                $path.AddArc($card.Width - $radius, $card.Height - $radius, $radius, $radius, 0, 90)
                $path.AddArc(0, $card.Height - $radius, $radius, $radius, 90, 90)
                $path.CloseAllFigures()
                $card.Region = New-Object System.Drawing.Region($path)
            
                # Icon
                $pic = New-Object System.Windows.Forms.PictureBox
                $pic.Size = New-Object System.Drawing.Size(24, 24)
                $pic.Location = New-Object System.Drawing.Point(10, 10)
                $pic.SizeMode = 'StretchImage'
                if (Test-Path $iconPath) {
                    $pic.Image = [System.Drawing.Image]::FromFile($iconPath)
                }
            
                # Title label
                $label = New-Object System.Windows.Forms.Label
                $label.Text = $title
                $label.ForeColor = [System.Drawing.Color]::White
                $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
                $label.Location = New-Object System.Drawing.Point(40, 12)
                $label.AutoSize = $true
            
                # Description label
                $desc = New-Object System.Windows.Forms.Label
                $desc.Text = $description
                $desc.ForeColor = [System.Drawing.Color]::LightGray
                $desc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $desc.Size = New-Object System.Drawing.Size(250, 32)
                $desc.Location = New-Object System.Drawing.Point(10, 42)
            
                if ($isToggle) {
                    $toggle = New-Object System.Windows.Forms.CheckBox
                    $toggle.Appearance = 'Button'
                    $toggle.FlatStyle = 'Flat'
                    $toggle.FlatAppearance.BorderSize = 0
                    $toggle.Text = "OFF"
                    $toggle.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                    $toggle.BackColor = [System.Drawing.Color]::FromArgb(80, 80, 90)
                    $toggle.ForeColor = [System.Drawing.Color]::White
                    $toggle.Size = New-Object System.Drawing.Size(130, 35)
                    $toggle.Location = New-Object System.Drawing.Point(70, 95)
            
                    $toggle.Add_CheckedChanged({
                        if ($toggle.Checked) {
                            $toggle.Text = "ON"
                            $toggle.BackColor = [System.Drawing.Color]::FromArgb(90, 160, 100)
                        } else {
                            $toggle.Text = "OFF"
                            $toggle.BackColor = [System.Drawing.Color]::FromArgb(80, 80, 90)
                        }
                        if ($onClick) { & $onClick }
                    })
            
                    $card.Controls.AddRange(@($pic, $label, $desc, $toggle))
                } else {
                    $btn = New-Object System.Windows.Forms.Button
                    $btn.Text = $buttonText
                    $btn.Size = New-Object System.Drawing.Size(130, 35)
                    $btn.Location = New-Object System.Drawing.Point(70, 95)
                    $btn.FlatStyle = 'Flat'
                    $btn.FlatAppearance.BorderSize = 0
                    $btn.BackColor = [System.Drawing.Color]::FromArgb(70, 100, 150)
                    $btn.ForeColor = [System.Drawing.Color]::White
                    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
            
                    $btn.Add_MouseEnter({ $btn.BackColor = [System.Drawing.Color]::FromArgb(90, 120, 180) })
                    $btn.Add_MouseLeave({ $btn.BackColor = [System.Drawing.Color]::FromArgb(70, 100, 150) })
            
                    if ($onClick) { $btn.Add_Click($onClick) }
            
                    $card.Controls.AddRange(@($pic, $label, $desc, $btn))
                }
            
                return $card
            }
            
            # Tweaks definitions
            $tweaks = @(
                @{ Title = "Create Restore Point";     Btn = "Create";   Action = { Write-Host "Restore Point created" }; IsToggle = $false },
                @{ Title = "Clear DNS Cache";          Btn = "Clear";    Action = { ipconfig /flushdns | Out-Null }; IsToggle = $false },
                @{ Title = "Toggle Search Bar";        Btn = "Toggle";   Action = { Write-Host "Toggled search bar" }; IsToggle = $true },
                @{ Title = "Toggle Location Tracking"; Btn = "Toggle";   Action = { Write-Host "Toggled location tracking" }; IsToggle = $true },
                @{ Title = "Toggle Teredo";            Btn = "Toggle";   Action = { Write-Host "Toggled Teredo" }; IsToggle = $true },
                @{ Title = "Toggle Hibernation";       Btn = "Toggle";   Action = { powercfg -h toggle }; IsToggle = $true },
                @{ Title = "Performance Display Mode"; Btn = "Apply";    Action = { rundll32.exe sysdm.cpl,EditEnvironmentVariables }; IsToggle = $false }
            )
            
            # Layout positions
            $startX = 20
            $startY = 20
            $gapX = 20
            $gapY = 20
            $cols = 3
            $row = 0
            $col = 0
            
            foreach ($tweak in $tweaks) {
                $x = $startX + ($col * (270 + $gapX))
                $y = $startY + ($row * (140 + $gapY))
                $icon = $iconPaths[$tweak.Title]
                $desc = $descriptions[$tweak.Title]
            
                $card = New-TweakCard -title $tweak.Title -buttonText $tweak.Btn -location ([System.Drawing.Point]::new($x, $y)) -onClick $tweak.Action -isToggle:$tweak.IsToggle -iconPath $icon -description $desc
                $panel.Controls.Add($card)
            
                $col++
                if ($col -ge $cols) {
                    $col = 0
                    $row++
                }
            }
            
            return $panel

        }
        "Cleaner" {
            Add-Type -AssemblyName System.Windows.Forms
            Add-Type -AssemblyName System.Drawing
            
            $panel = New-Object System.Windows.Forms.Panel
            $panel.Dock = 'Fill'
            $panel.BackColor = [System.Drawing.Color]::FromArgb(37, 37, 55)
            $panel.AutoScroll = $true
            
            # Icon mapping (local PNG files)
            $iconPaths = @{
                "Temp Files"        = "assets/icons/cleaner/trash.png"
                "Prefetch Files"    = "assets/icons/cleaner/rocket.png"
                "Recycle Bin"       = "assets/icons/cleaner/recycle.png"
                "Memory Standby"    = "assets/icons/cleaner/brain.png"
                "Software Dist"     = "assets/icons/cleaner/folder.png"
                "DNS Cache"         = "assets/icons/cleaner/globe.png"
            }
            
            function New-CleanerCard {
                param (
                    [string]$title,
                    [string]$description,
                    [ScriptBlock]$onClick,
                    [System.Drawing.Point]$location,
                    [string]$iconPath
                )
            
                $card = New-Object System.Windows.Forms.Panel
                $card.Size = New-Object System.Drawing.Size(270, 130)
                $card.Location = $location
                $card.BackColor = [System.Drawing.Color]::FromArgb(48, 48, 65)
            
                # Rounded Corners
                $radius = 10
                $path = New-Object System.Drawing.Drawing2D.GraphicsPath
                $path.AddArc(0, 0, $radius, $radius, 180, 90)
                $path.AddArc($card.Width - $radius, 0, $radius, $radius, 270, 90)
                $path.AddArc($card.Width - $radius, $card.Height - $radius, $radius, $radius, 0, 90)
                $path.AddArc(0, $card.Height - $radius, $radius, $radius, 90, 90)
                $path.CloseAllFigures()
                $card.Region = New-Object System.Drawing.Region($path)
            
                # Load icon image
                $pic = New-Object System.Windows.Forms.PictureBox
                $pic.Size = New-Object System.Drawing.Size(32, 32)
                $pic.Location = New-Object System.Drawing.Point(10, 10)
                $pic.SizeMode = 'StretchImage'
                if (Test-Path $iconPath) {
                    try {
                        $img = [System.Drawing.Image]::FromFile($iconPath)
                        $pic.Image = $img
                    } catch {
                        Write-Warning "Could not load image: $iconPath"
                    }
                }
            
                # Title label
                $lblTitle = New-Object System.Windows.Forms.Label
                $lblTitle.Text = $title
                $lblTitle.ForeColor = [System.Drawing.Color]::White
                $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
                $lblTitle.Location = New-Object System.Drawing.Point(50, 12)
                $lblTitle.AutoSize = $true
            
                # Description label
                $lblDesc = New-Object System.Windows.Forms.Label
                $lblDesc.Text = $description
                $lblDesc.ForeColor = [System.Drawing.Color]::LightGray
                $lblDesc.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                $lblDesc.Size = New-Object System.Drawing.Size(250, 40)
                $lblDesc.Location = New-Object System.Drawing.Point(10, 50)
            
                # Button
                $btn = New-Object System.Windows.Forms.Button
                $btn.Text = "Run"
                $btn.Size = New-Object System.Drawing.Size(80, 30)
                $btn.Location = New-Object System.Drawing.Point(170, 90)
                $btn.BackColor = [System.Drawing.Color]::FromArgb(90, 130, 190)
                $btn.FlatStyle = 'Flat'
                $btn.FlatAppearance.BorderSize = 0
                $btn.ForeColor = [System.Drawing.Color]::White
                $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
            
                $btn.Add_Click($onClick)
            
                $card.Controls.AddRange(@($pic, $lblTitle, $lblDesc, $btn))
                return $card
            }
            
            # Cleaner Options
            $cleaners = @(
                @{
                    Title = "Temp Files"; Desc = "Removes temporary files."; Act = {
                        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
                    }
                },
                @{
                    Title = "Prefetch Files"; Desc = "Cleans prefetch cache."; Act = {
                        Remove-Item "$env:SystemRoot\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
                    }
                },
                @{
                    Title = "Recycle Bin"; Desc = "Empties the Recycle Bin."; Act = {
                        (New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() | ForEach-Object {
                            Remove-Item $_.Path -Recurse -Force -ErrorAction SilentlyContinue
                        }
                    }
                },
                @{
                    Title = "Memory Standby"; Desc = "Flushes standby list."; Act = {
                        Start-Process -FilePath "empty.exe" -NoNewWindow
                    }
                },
                @{
                    Title = "Software Dist"; Desc = "Cleans update cache."; Act = {
                        Stop-Service wuauserv -Force
                        Remove-Item "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                        Start-Service wuauserv
                    }
                },
                @{
                    Title = "DNS Cache"; Desc = "Flushes DNS resolver."; Act = {
                        ipconfig /flushdns | Out-Null
                    }
                }
            )
            
            # Layout
            $startX = 20
            $startY = 20
            $gapX = 20
            $gapY = 20
            $cols = 3
            $row = 0
            $col = 0
            
            foreach ($c in $cleaners) {
                $x = $startX + ($col * (270 + $gapX))
                $y = $startY + ($row * (130 + $gapY))
                $iconFile = $iconPaths[$c.Title]
                $card = New-CleanerCard -title $c.Title -description $c.Desc -onClick $c.Act -location ([System.Drawing.Point]::new($x, $y)) -iconPath $iconFile
                $panel.Controls.Add($card)
            
                $col++
                if ($col -ge $cols) {
                    $col = 0
                    $row++
                }
            }
            
            return $panel

        }
        "Backup" {
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

        }
        "Utilities" {
            Add-Type -AssemblyName System.Windows.Forms
            Add-Type -AssemblyName System.Drawing
            
            $panel = New-Object System.Windows.Forms.Panel
            $panel.Dock = 'Fill'
            $panel.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 70)
            $panel.AutoScroll = $true
            
            # Utility definitions
            $utilities = @(
                @{ Title = "Task Manager";        Desc = "Monitor apps, processes, and system performance."; Cmd = "taskmgr"; Icon = "assets/icons/utils/taskmgr.png" },
                @{ Title = "Device Manager";      Desc = "Manage and view hardware devices and drivers.";     Cmd = "devmgmt.msc"; Icon = "assets/icons/utils/device.png" },
                @{ Title = "Disk Management";     Desc = "Create and format partitions and volumes.";         Cmd = "diskmgmt.msc"; Icon = "assets/icons/utils/disk.png" },
                @{ Title = "System Information";  Desc = "Detailed overview of your system hardware.";        Cmd = "msinfo32"; Icon = "assets/icons/utils/sysinfo.png" },
                @{ Title = "Command Prompt";      Desc = "Run command line tools and scripts.";               Cmd = "cmd.exe"; Icon = "assets/icons/utils/cmd.png" },
                @{ Title = "Registry Editor";     Desc = "Edit advanced Windows settings via registry.";      Cmd = "regedit"; Icon = "assets/icons/utils/registry.png" },
                @{ Title = "Services";            Desc = "View and manage running services.";                 Cmd = "services.msc"; Icon = "assets/icons/utils/services.png" },
                @{ Title = "Control Panel";       Desc = "Access classic Windows control settings.";          Cmd = "control"; Icon = "assets/icons/utils/control.png" },
                @{ Title = "System Properties";   Desc = "Advanced system settings and environment vars.";    Cmd = "SystemPropertiesAdvanced"; Icon = "assets/icons/utils/properties.png" }
            )
            
            # Function to create each card
            function New-UtilityCard {
                param (
                    [string]$title,
                    [string]$description,
                    [string]$command,
                    [System.Drawing.Point]$location,
                    [string]$iconPath
                )
            
                $card = New-Object System.Windows.Forms.Panel
                $card.Size = New-Object System.Drawing.Size(270, 130)
                $card.Location = $location
                $card.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 85)
            
                # Rounded corner region
                $radius = 10
                $path = New-Object System.Drawing.Drawing2D.GraphicsPath
                $path.AddArc(0, 0, $radius, $radius, 180, 90)
                $path.AddArc($card.Width - $radius, 0, $radius, $radius, 270, 90)
                $path.AddArc($card.Width - $radius, $card.Height - $radius, $radius, $radius, 0, 90)
                $path.AddArc(0, $card.Height - $radius, $radius, $radius, 90, 90)
                $path.CloseAllFigures()
                $card.Region = New-Object System.Drawing.Region($path)
            
                # Icon
                $icon = New-Object System.Windows.Forms.PictureBox
                $icon.Size = New-Object System.Drawing.Size(24, 24)
                $icon.Location = New-Object System.Drawing.Point(10, 10)
                $icon.SizeMode = 'StretchImage'
                if (Test-Path $iconPath) {
                    $icon.Image = [System.Drawing.Image]::FromFile($iconPath)
                }
            
                # Title
                $titleLabel = New-Object System.Windows.Forms.Label
                $titleLabel.Text = $title
                $titleLabel.ForeColor = [System.Drawing.Color]::White
                $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
                $titleLabel.Location = New-Object System.Drawing.Point(40, 12)
                $titleLabel.AutoSize = $true
            
                # Description
                $descLabel = New-Object System.Windows.Forms.Label
                $descLabel.Text = $description
                $descLabel.ForeColor = [System.Drawing.Color]::LightGray
                $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $descLabel.Size = New-Object System.Drawing.Size(250, 32)
                $descLabel.Location = New-Object System.Drawing.Point(10, 42)
            
                # Launch Button
                $btn = New-Object System.Windows.Forms.Button
                $btn.Text = "Launch"
                $btn.Size = New-Object System.Drawing.Size(120, 30)
                $btn.Location = New-Object System.Drawing.Point(75, 90)
                $btn.BackColor = [System.Drawing.Color]::FromArgb(90, 120, 180)
                $btn.ForeColor = [System.Drawing.Color]::White
                $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                $btn.FlatStyle = 'Flat'
                $btn.FlatAppearance.BorderSize = 0
                $btn.Add_Click({ Start-Process $command })
            
                $card.Controls.AddRange(@($icon, $titleLabel, $descLabel, $btn))
                return $card
            }
            
            # Positioning layout
            $startX = 20
            $startY = 20
            $gapX = 20
            $gapY = 20
            $cols = 3
            $col = 0
            $row = 0
            
            foreach ($tool in $utilities) {
                $x = $startX + ($col * (270 + $gapX))
                $y = $startY + ($row * (130 + $gapY))
                $card = New-UtilityCard -title $tool.Title -description $tool.Desc -command $tool.Cmd -location ([System.Drawing.Point]::new($x, $y)) -iconPath $tool.Icon
                $panel.Controls.Add($card)
            
                $col++
                if ($col -ge $cols) {
                    $col = 0
                    $row++
                }
            }
            
            return $panel

        }
        "Apps" {
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
