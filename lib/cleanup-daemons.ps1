$ErrorActionPreference = 'SilentlyContinue'

Write-Host "========================================"  -ForegroundColor Cyan
Write-Host "  CCB Cleanup Script" -ForegroundColor Cyan
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host ""

# [1/5] Cleanup laskd daemon processes
Write-Host "[1/5] Cleanup laskd daemon processes..." -ForegroundColor White
$processes = Get-Process -Name python -ErrorAction SilentlyContinue | Where-Object {
    try {
        $cmd = (Get-WmiObject Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
        $cmd -like '*laskd*' -or $cmd -like '*ccb*'
    } catch { false }
}
if ($processes) {
    $processes | Stop-Process -Force -ErrorAction SilentlyContinue
    $count = $processes.Count
    if ($count -gt 99) { $count = '99+' }
    Write-Host "  Stopped $count daemon processes" -ForegroundColor Yellow
} else {
    Write-Host "  No running daemon processes" -ForegroundColor Gray
}
Write-Host ""

# [2/5] Cleanup lock files
Write-Host "[2/5] Cleanup lock files..." -ForegroundColor White
$lockPath = Join-Path $env:USERPROFILE '.ccb\run'
if (Test-Path $lockPath) {
    $locks = Get-ChildItem -Path $lockPath -Filter 'laskd*.lock' -ErrorAction SilentlyContinue
    if ($locks) {
        $locks | Remove-Item -Force -ErrorAction SilentlyContinue
        $count = $locks.Count
        if ($count -gt 99) { $count = '99+' }
        Write-Host "  Removed $count lock files" -ForegroundColor Yellow
    } else {
        Write-Host "  No lock files" -ForegroundColor Gray
    }
} else {
    Write-Host "  Lock directory not found" -ForegroundColor Gray
}
Write-Host ""

# [3/5] Cleanup daemon state files
Write-Host "[3/5] Cleanup daemon state files..." -ForegroundColor White
$statePaths = @(
    Join-Path $env:LOCALAPPDATA 'ccb',
    Join-Path $env:USERPROFILE '.cache\ccb'
)
$count = 0
foreach ($basePath in $statePaths) {
    if (Test-Path $basePath) {
        $stateFiles = Get-ChildItem -Path $basePath -Recurse -Filter 'laskd*.json' -ErrorAction SilentlyContinue
        if ($stateFiles) {
            $stateFiles | Remove-Item -Force -ErrorAction SilentlyContinue
            $count += $stateFiles.Count
        }
    }
}
if ($count -gt 0) {
    Write-Host "  Removed $count state files" -ForegroundColor Yellow
} else {
    Write-Host "  No state files" -ForegroundColor Gray
}
Write-Host ""

# [4/5] Cleanup temp task files
Write-Host "[4/5] Cleanup temp task files..." -ForegroundColor White
$tempPath = Join-Path $env:TEMP 'ccb-tasks'
if (Test-Path $tempPath) {
    $tempFiles = Get-ChildItem -Path $tempPath -Recurse -ErrorAction SilentlyContinue
    if ($tempFiles) {
        $count = (Get-ChildItem -Path $tempPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
        Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Removed $count temp files" -ForegroundColor Yellow
    } else {
        Write-Host "  No temp files" -ForegroundColor Gray
    }
} else {
    Write-Host "  Temp directory not found" -ForegroundColor Gray
}
Write-Host ""

# [5/5] Cleanup daemon log files
Write-Host "[5/5] Cleanup daemon log files..." -ForegroundColor White
$logPaths = @(
    Join-Path $env:LOCALAPPDATA 'ccb',
    Join-Path $env:USERPROFILE '.cache\ccb'
)
$count = 0
foreach ($basePath in $logPaths) {
    if (Test-Path $basePath) {
        $logFiles = Get-ChildItem -Path $basePath -Recurse -Filter 'laskd*.log' -ErrorAction SilentlyContinue
        if ($logFiles) {
            $logFiles | Remove-Item -Force -ErrorAction SilentlyContinue
            $count += $logFiles.Count
        }
    }
}
if ($count -gt 0) {
    Write-Host "  Removed $count log files" -ForegroundColor Yellow
} else {
    Write-Host "  No log files" -ForegroundColor Gray
}
Write-Host ""

Write-Host "========================================"  -ForegroundColor Green
Write-Host "  [OK] Cleanup complete!" -ForegroundColor Green
Write-Host "========================================"  -ForegroundColor Green
Write-Host ""
