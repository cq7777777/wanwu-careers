$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Join-Path $root 'repo'
$src = Join-Path $root 'careers.html'
Set-Location $repo

if (!(Test-Path $src)) { Write-Host '[X] careers.html not found' -ForegroundColor Red; exit 1 }

Write-Host '[1/4] Copying careers.html -> repo/index.html, repo/careers.html' -ForegroundColor Cyan
Copy-Item $src (Join-Path $repo 'index.html') -Force
Copy-Item $src (Join-Path $repo 'careers.html') -Force

git config user.email 'dev@wanwu.com' 2>$null
git config user.name 'dev' 2>$null

git add -A
$stat = git diff --cached --stat
if (-not $stat) { Write-Host '[OK] No changes to commit' -ForegroundColor Green; exit 0 }

Write-Host '[2/4] Staged:' -ForegroundColor DarkGray
$stat | Out-Host

$msg = if ($args.Count -gt 0) { $args -join ' ' } else { "update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" }

Write-Host "[3/4] Committing: $msg" -ForegroundColor Cyan
git commit -m $msg | Out-Host

Write-Host '[4/4] Pushing to GitHub...' -ForegroundColor Cyan
git push origin main 2>&1 | Out-Host

Write-Host ''
Write-Host 'DONE. Pages will auto-update in ~60s' -ForegroundColor Green
Write-Host '  -> https://cq7777777.github.io/wanwu-careers/' -ForegroundColor Yellow
