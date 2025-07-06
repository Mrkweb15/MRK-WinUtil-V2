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
