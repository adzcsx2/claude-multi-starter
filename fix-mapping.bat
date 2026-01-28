@echo off
REM 从 WezTerm 标签页内创建映射的批处理脚本
REM 解决 Python subprocess 环境变量问题

echo [INFO] Creating tab mapping from WezTerm CLI...
echo.

REM 直接运行 wezterm cli list 并保存到临时文件
wezterm cli list > temp_panes.txt 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] wezterm cli list failed
    echo.
    echo Make sure you are running this FROM INSIDE a WezTerm tab
    type temp_panes.txt
    del temp_panes.txt
    pause
    exit /b 1
)

echo [OK] Got pane list from WezTerm
type temp_panes.txt
echo.

REM 使用 Python 解析并创建映射
python -c "import sys; lines = open('temp_panes.txt', 'r', encoding='utf-8', errors='ignore').readlines(); panes = []; [panes.append(int(line.split()[2])) for line in lines[1:] if len(line.split()) >= 3 and line.split()[2].isdigit()]; print(f'Found {len(panes)} panes: {panes[:3]}'); import json; from pathlib import Path; config_dir = Path('.cms_config'); config_dir.mkdir(exist_ok=True); mapping = {'work_dir': str(Path.cwd()), 'tabs': {'c1': {'pane_id': str(panes[0]), 'role': 'Design'}, 'c2': {'pane_id': str(panes[1]), 'role': 'Main'}, 'c3': {'pane_id': str(panes[2]), 'role': 'Test'}}, 'created_at': 0}; open(config_dir / 'tab_mapping.json', 'w', encoding='utf-8').write(json.dumps(mapping, indent=2)); print('\n[OK] Mapping created!'); print(f'  c1 -> pane {panes[0]}'); print(f'  c2 -> pane {panes[1]}'); print(f'  c3 -> pane {panes[2]}')" 2>&1

del temp_panes.txt

echo.
echo [SUCCESS] Tab mapping created in .cms_config\tab_mapping.json
echo.
echo Test with:
echo   python send-tab.py c1 "继续"
echo.
pause
