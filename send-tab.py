#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
直接使用 tab_index 发送消息到 Windows Terminal 标签页
"""

import sys
import json
import subprocess
from pathlib import Path


def load_config():
    work_dir = Path.cwd()
    mapping_file = work_dir / ".cms_config" / "tab_mapping.json"

    if not mapping_file.exists():
        return None

    try:
        with open(mapping_file, "r", encoding="utf-8-sig") as f:
            mapping = json.load(f)
    except:
        with open(mapping_file, "r", encoding="utf-8") as f:
            mapping = json.load(f)

    return mapping.get("tabs", {})


def main():
    if len(sys.argv) < 3:
        print("Usage: send-tab <instance> <message>")
        print("Examples:")
        print("  python send-tab.py c1 '继续'")
        print("  python send-tab.py c2 '继续'")
        return 1

    instance = sys.argv[1].lower()
    message = " ".join(sys.argv[2:])

    tabs = load_config()

    if not tabs:
        print("[ERROR] Could not load tab_mapping.json")
        return 1

    if instance not in tabs:
        print(f"[ERROR] Unknown instance '{instance}'")
        print(f"Available: {', '.join(tabs.keys())}")
        return 1

    tab_info = tabs[instance]
    tab_index = tab_info.get("tab_index", tab_info.get("pane_id", "0"))

    try:
        # Copy message to clipboard using PowerShell
        # Escape the message for PowerShell
        escaped_msg = message.replace("'", "''")
        
        ps_script = f"""
# Copy to clipboard
Set-Clipboard -Value '{escaped_msg}'
# Focus the target tab
wt.exe -w 0 focus-tab -t {tab_index}
"""
        
        result = subprocess.run(
            ["powershell", "-Command", ps_script],
            capture_output=True,
            text=True,
            encoding='utf-8',
            timeout=2,
        )
        
        if result.returncode == 0:
            print(f"[OK] Focused {instance} (tab {tab_index})")
            print(f"[INFO] Message copied to clipboard: '{message}'")
            print(f"[ACTION] Press Ctrl+V in the {instance} window and Enter to send")
            return 0
        else:
            print(f"[ERROR] Failed: {result.stderr}")
            return 1

    except Exception as e:
        print(f"[ERROR] {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
