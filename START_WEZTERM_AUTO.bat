@echo off
REM 自动启动 WezTerm 并创建 3 个标签页
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ============================================================
echo          启动 WezTerm 多标签页环境
echo ============================================================
echo.

REM 查找 WezTerm
set WEZTERM_BIN=
for %%p in (wezterm.exe) do (
    set WEZTERM_BIN=%%~$PATH:p
)

if not defined WEZTERM_BIN (
    set "WEZTERM_BIN=%ProgramFiles%\WezTerm\wezterm.exe"
)

if not exist "%WEZTERM_BIN%" (
    echo [ERROR] WezTerm not found
    echo Please install from: https://wezfurlong.org/wezterm/
    pause
    exit /b 1
)

echo [OK] Found WezTerm: %WEZTERM_BIN%
echo.

REM 启动 WezTerm 窗口，每个标签页用分号分隔
echo [*] Launching WezTerm with 3 tabs...
echo.

start "" "%WEZTERM_BIN%" ^
  start --cwd "%CD%" pwsh -NoExit -Command "Write-Host '[C1-Design] Ready'; $Host.UI.RawUI.WindowTitle = 'C1-Design'; claude --dangerously-skip-permissions" ; ^
  new-tab --cwd "%CD%" pwsh -NoExit -Command "Write-Host '[C2-Main] Ready'; $Host.UI.RawUI.WindowTitle = 'C2-Main'; claude --dangerously-skip-permissions" ; ^
  new-tab --cwd "%CD%" pwsh -NoExit -Command "Write-Host '[C3-Test] Ready'; $Host.UI.RawUI.WindowTitle = 'C3-Test'; claude --dangerously-skip-permissions"

echo [OK] WezTerm launched
echo.
echo Waiting for initialization...
timeout /t 5 /nobreak >nul

REM 创建 tab mapping
echo [*] Creating tab mapping...
python fix-mapping.py

echo.
echo ============================================================
echo [SUCCESS] All tabs ready!
echo ============================================================
echo.
echo Use this to send messages:
echo   python send-tab.py c1 "继续"
echo   python send-tab.py c2 "继续"
echo   python send-tab.py c3 "继续"
echo.
pause
