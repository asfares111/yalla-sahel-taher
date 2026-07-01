Add-Type -AssemblyName System.Drawing

function New-RoundedRectanglePath {
  param(
    [System.Drawing.Rectangle]$Rectangle,
    [int]$Radius
  )

  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $diameter = $Radius * 2
  $path.AddArc($Rectangle.X, $Rectangle.Y, $diameter, $diameter, 180, 90)
  $path.AddArc($Rectangle.Right - $diameter, $Rectangle.Y, $diameter, $diameter, 270, 90)
  $path.AddArc($Rectangle.Right - $diameter, $Rectangle.Bottom - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc($Rectangle.X, $Rectangle.Bottom - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  return $path
}

$root = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $root 'assets\homepage-carousel\screenshots\IMG_5265.PNG'
$outputPath = Join-Path $root 'assets\yalla-sahel-social-preview.png'

$canvas = New-Object System.Drawing.Bitmap 1200, 630
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$bounds = New-Object System.Drawing.Rectangle 0, 0, 1200, 630
$background = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  $bounds,
  [System.Drawing.Color]::FromArgb(255, 255, 255, 255),
  [System.Drawing.Color]::FromArgb(255, 227, 242, 255),
  30
)
$graphics.FillRectangle($background, $bounds)
$graphics.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 8, 120, 255))), 0, 0, 1200, 8)
$graphics.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 34, 166, 255))), 34, 430, 290, 290)
$graphics.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(34, 38, 205, 243))), 925, 34, 250, 250)

$source = [System.Drawing.Image]::FromFile($sourcePath)

# Reuse the official Yalla Sahel mark already visible in the supplied platform capture.
$graphics.DrawImage($source, (New-Object System.Drawing.Rectangle 72, 58, 135, 72), (New-Object System.Drawing.Rectangle 75, 8, 110, 64), [System.Drawing.GraphicsUnit]::Pixel)

$deep = [System.Drawing.Color]::FromArgb(255, 11, 29, 51)
$muted = [System.Drawing.Color]::FromArgb(255, 83, 109, 139)
$blue = [System.Drawing.Color]::FromArgb(255, 8, 120, 255)
$white = [System.Drawing.Color]::White

$pillPath = New-RoundedRectanglePath (New-Object System.Drawing.Rectangle 72, 174, 306, 42) 21
$graphics.FillPath((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 255, 255, 255))), $pillPath)
$graphics.DrawPath((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(35, 8, 120, 255), 1)), $pillPath)
$graphics.DrawString('BEACH OPERATIONS PLATFORM', (New-Object System.Drawing.Font('Arial', 14, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush($blue)), 91, 185)

$headlineFont = New-Object System.Drawing.Font('Arial', 43, [System.Drawing.FontStyle]::Bold)
$bodyFont = New-Object System.Drawing.Font('Arial', 16, [System.Drawing.FontStyle]::Regular)
$nameFont = New-Object System.Drawing.Font('Arial', 18, [System.Drawing.FontStyle]::Bold)
$titleFont = New-Object System.Drawing.Font('Arial', 15, [System.Drawing.FontStyle]::Regular)
$graphics.DrawString('Manage every beach operation' + [Environment]::NewLine + 'from one dashboard.', $headlineFont, (New-Object System.Drawing.SolidBrush($deep)), (New-Object System.Drawing.RectangleF 72, 240, 545, 130))
$graphics.DrawString('Tickets, memberships, QR check-ins, POS sales, live capacity and reporting.', $bodyFont, (New-Object System.Drawing.SolidBrush($muted)), (New-Object System.Drawing.RectangleF 72, 402, 500, 45))

$avatarPath = New-RoundedRectanglePath (New-Object System.Drawing.Rectangle 72, 497, 54, 54) 16
$graphics.FillPath((New-Object System.Drawing.SolidBrush($blue)), $avatarPath)
$avatarFormat = New-Object System.Drawing.StringFormat
$avatarFormat.Alignment = [System.Drawing.StringAlignment]::Center
$avatarFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
$graphics.DrawString('AF', (New-Object System.Drawing.Font('Arial', 17, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush($white)), (New-Object System.Drawing.RectangleF 72, 497, 54, 54), $avatarFormat)
$graphics.DrawString('Amir Fares', $nameFont, (New-Object System.Drawing.SolidBrush($deep)), 143, 502)
$graphics.DrawString('Head of Business Development & Partnerships', $titleFont, (New-Object System.Drawing.SolidBrush($muted)), 143, 527)

$frame = New-Object System.Drawing.Rectangle 596, 54, 656, 544
$shadowPath = New-RoundedRectanglePath (New-Object System.Drawing.Rectangle 604, 66, 656, 544) 26
$graphics.FillPath((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(28, 6, 64, 130))), $shadowPath)
$framePath = New-RoundedRectanglePath $frame 26
$graphics.FillPath((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(238, 255, 255, 255))), $framePath)
$graphics.SetClip((New-RoundedRectanglePath (New-Object System.Drawing.Rectangle 610, 68, 628, 516) 18))
$graphics.DrawImage($source, (New-Object System.Drawing.Rectangle 610, 68, 628, 516))
$graphics.ResetClip()
$graphics.DrawPath((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 255, 255), 2)), $framePath)

$source.Dispose()
$background.Dispose()
$graphics.Dispose()
$canvas.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$canvas.Dispose()
