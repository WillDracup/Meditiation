# Live-reload dev server for the meditation app.
# Edit any file, save, and every open browser (desktop + phone) refreshes itself.
# No commit, no push, no GitHub Pages build, no stale cache.

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# Find this machine's LAN IPv4 so you can open the app on your phone.
$lan = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp,Manual `
        -ErrorAction SilentlyContinue |
        Where-Object { $_.IPAddress -notlike "169.254.*" } |
        Select-Object -First 1).IPAddress
if (-not $lan) { $lan = "localhost" }

$port = 5173

Write-Host ""
Write-Host "  Singing Bowl - dev server" -ForegroundColor Yellow
Write-Host "  -------------------------"
Write-Host "  Desktop : " -NoNewline; Write-Host "http://localhost:$port"      -ForegroundColor Cyan
Write-Host "  Phone   : " -NoNewline; Write-Host "http://${lan}:$port"          -ForegroundColor Cyan
Write-Host "            (phone must be on the same WiFi)"
Write-Host ""
Write-Host "  Save a file to reload. Press Ctrl+C to stop." -ForegroundColor DarkGray
Write-Host ""

# live-server: zero-config static server with websocket live-reload.
# --no-browser keeps it from opening a tab every restart; remove if you want auto-open.
npx -y live-server --host=0.0.0.0 --port=$port --no-browser --wait=200
