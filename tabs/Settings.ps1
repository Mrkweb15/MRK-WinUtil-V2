$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = 'Fill'
$panel.BackColor = [System.Drawing.Color]::FromArgb(37, 37, 55)

$label = New-Object System.Windows.Forms.Label
$label.Text = "⚙️ App Settings"
$label.ForeColor = [System.Drawing.Color]::White
$label.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 20)

$panel.Controls.Add($label)
return $panel
