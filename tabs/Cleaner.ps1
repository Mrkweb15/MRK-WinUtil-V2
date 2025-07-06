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
