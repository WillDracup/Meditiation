# One-command deploy to GitHub Pages.
# Auto-bumps the service-worker cache version (so phones pick up the new build),
# commits everything, and pushes. Pages rebuilds in ~1 minute.
#
# Usage:  .\deploy.ps1            (uses a default commit message)
#         .\deploy.ps1 "message"  (custom commit message)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$msg = if ($args.Count -gt 0) { $args[0] } else { "Update app" }

# --- bump CACHE = "bowl-vN" -> "bowl-v(N+1)" in sw.js ---
$swPath = Join-Path $PSScriptRoot "sw.js"
$sw = Get-Content $swPath -Raw
$m = [regex]::Match($sw, 'const CACHE = "bowl-v(\d+)";')
if (-not $m.Success) { throw "Could not find the CACHE version line in sw.js" }
$old = [int]$m.Groups[1].Value
$new = $old + 1
$sw = $sw -replace 'const CACHE = "bowl-v\d+";', "const CACHE = `"bowl-v$new`";"
Set-Content $swPath -Value $sw -NoNewline
Write-Host "  Cache version: bowl-v$old -> bowl-v$new" -ForegroundColor Yellow

# --- commit & push ---
git add -A
git commit -m "$msg`n`nCo-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
git push origin main

Write-Host ""
Write-Host "  Pushed. GitHub Pages rebuilds in ~1 min." -ForegroundColor Green
Write-Host "  Live: https://willdracup.github.io/Meditiation/" -ForegroundColor Cyan
