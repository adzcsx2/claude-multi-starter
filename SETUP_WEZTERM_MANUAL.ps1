# 简化版：手动启动 3 个 WezTerm 标签页然后创建映射
[CmdletBinding()]
param()

$PROJECT_DIR = (Get-Location).Path

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "    WezTerm Multi-Tab Setup (Manual Method)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "STEPS TO FOLLOW:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open WezTerm manually" -ForegroundColor White
Write-Host "2. Create 3 tabs total (use Ctrl+Shift+T to create new tabs)" -ForegroundColor White
Write-Host "3. In each tab, run:" -ForegroundColor White
Write-Host ""  
Write-Host "   Tab 1 (C1): cd $PROJECT_DIR ; claude --dangerously-skip-permissions" -ForegroundColor Cyan
Write-Host "   Tab 2 (C2): cd $PROJECT_DIR ; claude --dangerously-skip-permissions" -ForegroundColor Cyan  
Write-Host "   Tab 3 (C3): cd $PROJECT_DIR ; claude --dangerously-skip-permissions" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. After all 3 tabs are running, come back here and press Enter" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter when all 3 tabs are ready"

Write-Host ""
Write-Host "[*] Creating tab mapping..." -ForegroundColor Cyan

# 获取 pane 列表
$weztermPath = "C:\Program Files\WezTerm\wezterm.exe"
$listOutput = & $weztermPath cli list --format json 2>$null

if (-not $listOutput) {
    Write-Host "[ERROR] Cannot connect to WezTerm" -ForegroundColor Red
    Write-Host "Make sure WezTerm is running with at least 3 tabs" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

$panes = @()
foreach ($line in $listOutput -split "`n") {
    if ($line.Trim()) {
        try {
            $panes += ($line | ConvertFrom-Json)
        } catch {}
    }
}

Write-Host "[OK] Found $($panes.Count) panes" -ForegroundColor Green

if ($panes.Count -lt 3) {
    Write-Host "[ERROR] Need at least 3 panes, found $($panes.Count)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# 创建映射
$configDir = Join-Path $PROJECT_DIR ".cms_config"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

$mapping = @{
    work_dir = $PROJECT_DIR
    tabs = @{
        c1 = @{
            pane_id = [string]$panes[0].pane_id
            role = "Design"
        }
        c2 = @{
            pane_id = [string]$panes[1].pane_id
            role = "Main"
        }
        c3 = @{
            pane_id = [string]$panes[2].pane_id
            role = "Test"
        }
    }
    created_at = [int](Get-Date -UFormat %s)
}

$mappingFile = Join-Path $configDir "tab_mapping.json"
$mapping | ConvertTo-Json -Depth 10 | Set-Content -Path $mappingFile -Encoding UTF8

Write-Host "[OK] Tab mapping created!" -ForegroundColor Green
Write-Host ""
Write-Host "Pane mappings:" -ForegroundColor Cyan
Write-Host "  c1 (Design) -> pane $($panes[0].pane_id)" -ForegroundColor White
Write-Host "  c2 (Main)   -> pane $($panes[1].pane_id)" -ForegroundColor White
Write-Host "  c3 (Test)   -> pane $($panes[2].pane_id)" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] Setup complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test with:" -ForegroundColor Yellow
Write-Host "  python send-tab.py c1 `"继续`"" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to close"
