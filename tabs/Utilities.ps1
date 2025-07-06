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
