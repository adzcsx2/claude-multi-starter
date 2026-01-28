#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
快速修复：创建c1, c2, c3的映射

运行这个脚本来修复实例名不匹配的问题
"""

import json
from pathlib import Path

project_dir = Path.cwd()
config_dir = project_dir / ".cms_config"
mapping_file = config_dir / "tab_mapping.json"

if not mapping_file.exists():
    print(f"[ERROR] {mapping_file} not found")
    exit(1)

# 读取现有映射 (处理BOM)
try:
    with open(mapping_file, "r", encoding="utf-8-sig") as f:
        mapping = json.load(f)
except:
    with open(mapping_file, "r", encoding="utf-8") as f:
        mapping = json.load(f)

# 获取现有的pane_id
tabs = mapping.get("tabs", {})
pane_ids = []

# 优先使用 ui, coder, test
for key in ["ui", "coder", "test"]:
    if key in tabs and "pane_id" in tabs[key]:
        pane_ids.append(tabs[key]["pane_id"])

# 如果没有找到3个，尝试使用任意3个
if len(pane_ids) < 3:
    pane_ids = []
    for key, value in tabs.items():
        if "pane_id" in value:
            pane_ids.append(value["pane_id"])
        if len(pane_ids) >= 3:
            break

if len(pane_ids) < 3:
    print("[ERROR] Not enough panes found in tab_mapping.json")
    print(f"Found: {list(tabs.keys())}")
    print("\nPlease make sure you have started 3 Claude windows")
    exit(1)

# 创建新的映射 c1, c2, c3
new_tabs = {
    "c1": {
        "pane_id": pane_ids[0],  # ui的pane_id
        "role": "Design (C1)"
    },
    "c2": {
        "pane_id": pane_ids[1],  # coder的pane_id
        "role": "Development (C2)"
    },
    "c3": {
        "pane_id": pane_ids[2],  # test的pane_id
        "role": "Testing (C3)"
    }
}

# 保留旧的映射，添加新的
tabs.update(new_tabs)
mapping["tabs"] = tabs

# 保存
with open(mapping_file, "w", encoding="utf-8") as f:
    json.dump(mapping, f, indent=2, ensure_ascii=False)

print("[OK] Tab mapping updated!")
print("")
print("Added mappings:")
print(f"  c1 -> pane {pane_ids[0]} (Design)")
print(f"  c2 -> pane {pane_ids[1]} (Development)")
print(f"  c3 -> pane {pane_ids[2]} (Testing)")
print("")
print("Now you can use:")
print("  python bin/send c1 '继续'")
print("  python bin/send c2 '继续'")
print("  python bin/send c3 '继续'")
