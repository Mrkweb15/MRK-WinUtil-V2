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
