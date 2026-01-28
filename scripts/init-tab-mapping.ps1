# Initialize Tab Mapping for Automation Mode
# This script creates the correct tab_mapping.json file

param(
    [string]$ProjectDir = (Get-Location).Path
)

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Initializing tab mapping..." -ForegroundColor Cyan

# Create .cms_config directory if not exists
$configDir = Join-Path $ProjectDir ".cms_config"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

# Get all panes in current window
$panes = wt.exe -w 0 query | ConvertFrom-Json 2>$null

if ($null -eq $panes -or $panes.Count -eq 0) {
    Write-Host "[ERROR] Cannot detect Windows Terminal panes" -ForegroundColor Red
    Write-Host "Please make sure you're running in Windows Terminal" -ForegroundColor Yellow
    exit 1
}

# Sort panes by index
$sortedPanes = $panes | Sort-Object -Property tabIndex, paneIndex

# Map first 3 panes to c1, c2, c3
$mapping = @{
    work_dir = $ProjectDir
    tabs = @{
        c1 = @{
            pane_id = $sortedPanes[0].id.ToString()
            role = "Design (C1)"
        }
        c2 = @{
            pane_id = $sortedPanes[1].id.ToString()
            role = "Development (C2)"
        }
        c3 = @{
            pane_id = $sortedPanes[2].id.ToString()
            role = "Testing (C3)"
        }
    }
    created_at = [int](Get-Date -UFormat %s)
}

# Save to tab_mapping.json
$mappingFile = Join-Path $configDir "tab_mapping.json"
$mapping | ConvertTo-Json -Depth 10 | Set-Content -Path $mappingFile -Encoding UTF8

Write-Host "[OK] Tab mapping created:" -ForegroundColor Green
Write-Host "  c1 -> pane $($sortedPanes[0].id) (Design)" -ForegroundColor Cyan
Write-Host "  c2 -> pane $($sortedPanes[1].id) (Development)" -ForegroundColor Cyan
Write-Host "  c3 -> pane $($sortedPanes[2].id) (Testing)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Saved to: $mappingFile" -ForegroundColor Green
Write-Host ""
Write-Host "You can now use:" -ForegroundColor Yellow
Write-Host "  python bin/send c1 '继续'" -ForegroundColor White
Write-Host "  python bin/send c2 '继续'" -ForegroundColor White
Write-Host "  python bin/send c3 '继续'" -ForegroundColor White
