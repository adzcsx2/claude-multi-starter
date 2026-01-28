#!/usr/bin/env python3
"""
简单的 WezTerm 3标签页启动器
使用最基本的方式：启动3个独立的 wezterm start 命令
"""
import subprocess
import time
import shutil
from pathlib import Path

def find_wezterm():
    wt = shutil.which("wezterm") or shutil.which("wezterm.exe")
    if not wt:
        common = Path("C:/Program Files/WezTerm/wezterm.exe")
        if common.exists():
            return str(common)
    return wt

def main():
    wezterm = find_wezterm()
    if not wezterm:
        print("[ERROR] WezTerm not found")
        return 1
    
    print(f"[OK] Found: {wezterm}")
    print()
    print("=" * 60)
    print("  Launching 3 separate WezTerm windows...")
    print("=" * 60)
    print()
    
    cwd = str(Path.cwd())
    
    # 启动3个独立的 WezTerm 窗口
    instances = [
        ("c1", "Design"),
        ("c2", "Main"),
        ("c3", "Test")
    ]
    
    for inst_id, role in instances:
        print(f"[*] Starting {inst_id} - {role}...")
        cmd = [
            wezterm,
            "start",
            "--cwd", cwd,
            "pwsh", "-NoExit",
            "-Command",
            f"Write-Host '[{inst_id} - {role}] Ready'; claude --dangerously-skip-permissions"
        ]
        
        subprocess.Popen(cmd)
        time.sleep(2)  # 给每个窗口启动时间
    
    print()
    print("[OK] All windows launched")
    print()
    print("=" * 60)
    print("  Creating tab mapping...")
    print("=" * 60)
    print()
    time.sleep(3)
    
    # 获取所有 panes
    result = subprocess.run(
        [wezterm, "cli", "list", "--format", "json"],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print("[WARN] Could not get pane list")
        print("You may need to run: python fix-mapping.py")
        return 0
    
    import json
    panes = []
    for line in result.stdout.strip().split("\n"):
        if line.strip():
            try:
                panes.append(json.loads(line))
            except:
                pass
    
    if len(panes) < 3:
        print(f"[WARN] Found only {len(panes)} panes, need 3")
        print("Manual mapping may be needed")
        return 0
    
    # 创建映射
    config_dir = Path.cwd() / ".cms_config"
    config_dir.mkdir(exist_ok=True)
    
    mapping = {
        "work_dir": cwd,
        "tabs": {
            "c1": {"pane_id": str(panes[0]["pane_id"]), "role": "Design"},
            "c2": {"pane_id": str(panes[1]["pane_id"]), "role": "Main"},
            "c3": {"pane_id": str(panes[2]["pane_id"]), "role": "Test"},
        },
        "created_at": int(time.time())
    }
    
    mapping_file = config_dir / "tab_mapping.json"
    with open(mapping_file, "w", encoding="utf-8") as f:
        json.dump(mapping, f, indent=2)
    
    print(f"[OK] Mapping created: {mapping_file}")
    print()
    print("=" * 60)
    print("[SUCCESS] Setup complete!")
    print("=" * 60)
    print()
    print("Test with:")
    print('  python send-tab.py c1 "继续"')
    print()
    
    return 0

if __name__ == "__main__":
    try:
        exit(main())
    except KeyboardInterrupt:
        print("\n[!] Interrupted")
        exit(130)
