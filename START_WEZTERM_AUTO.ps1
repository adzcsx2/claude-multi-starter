# 自动启动 WezTerm 并创建 3 个标签页
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$PROJECT_DIR = (Get-Location).Path

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "         Launch WezTerm Multi-Tab Environment" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 查找 WezTerm
$weztermPath = $null
$weztermPaths = @(
    (Get-Command wezterm -ErrorAction SilentlyContinue).Source,
    (Get-Command wezterm.exe -ErrorAction SilentlyContinue).Source,
    "$env:ProgramFiles\WezTerm\wezterm.exe"
)

foreach ($path in $weztermPaths) {
    if ($path -and (Test-Path $path)) {
        $weztermPath = $path
        break
    }
}

if (-not $weztermPath) {
    Write-Host "[ERROR] WezTerm not found" -ForegroundColor Red
    Write-Host "Please install from: https://wezfurlong.org/wezterm/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[OK] Found WezTerm: $weztermPath" -ForegroundColor Green
Write-Host ""

# 启动 WezTerm 多标签页
Write-Host "[*] Launching WezTerm with 3 tabs..." -ForegroundColor Cyan
Write-Host ""

try {
    # 方法1: 使用 wezterm 的分号语法启动多标签页
    # 注意: 在 Windows 上需要用引号包裹整个命令
    
    Write-Host "[*] Method: Using PowerShell Start-Process with argument array" -ForegroundColor Cyan
    
    # 构建命令字符串
    $cmdString = "start --cwd `"$PROJECT_DIR`" pwsh -NoExit -Command `"Write-Host '[C1] Ready'; claude --dangerously-skip-permissions`" ; new-tab --cwd `"$PROJECT_DIR`" pwsh -NoExit -Command `"Write-Host '[C2] Ready'; claude --dangerously-skip-permissions`" ; new-tab --cwd `"$PROJECT_DIR`" pwsh -NoExit -Command `"Write-Host '[C3] Ready'; claude --dangerously-skip-permissions`""
    
    Write-Host "[DEBUG] Command: $cmdString" -ForegroundColor Gray
    
    Start-Process -FilePath $weztermPath -ArgumentList $cmdString

    Write-Host "[OK] WezTerm launch command sent" -ForegroundColor Green
    Write-Host ""
    Write-Host "Waiting for WezTerm to start..." -ForegroundColor Cyan
    Start-Sleep -Seconds 8

    # 创建 tab mapping
    Write-Host "[*] Creating tab mapping..." -ForegroundColor Cyan
    
    # 手动获取 pane IDs 并创建映射
    $weztermListResult = & $weztermPath cli list --format json 2>$null
    
    if ($weztermListResult) {
        $panes = @()
        foreach ($line in $weztermListResult -split "`n") {
            if ($line.Trim()) {
                try {
                    $panes += ($line | ConvertFrom-Json)
                } catch {}
            }
        }

        if ($panes.Count -ge 3) {
            Write-Host "[OK] Found $($panes.Count) panes" -ForegroundColor Green
            
            # 创建映射文件
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
            
            Write-Host "[OK] Tab mapping created: $mappingFile" -ForegroundColor Green
        } else {
            Write-Host "[WARN] Could not get all panes, manual mapping may be needed" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[WARN] WezTerm CLI not ready yet, manual mapping may be needed" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "[SUCCESS] All tabs ready!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Use this to send messages:" -ForegroundColor Yellow
    Write-Host "  python send-tab.py c1 `"继续`"" -ForegroundColor White
    Write-Host "  python send-tab.py c2 `"继续`"" -ForegroundColor White
    Write-Host "  python send-tab.py c3 `"继续`"" -ForegroundColor White
    Write-Host ""

} catch {
    Write-Host "[ERROR] Failed to launch WezTerm" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Press Enter to close..." -ForegroundColor Gray
Read-Host
