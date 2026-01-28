#!/usr/bin/env python3
"""
测试 WezTerm CLI 命令
⚠️ 必须在 WezTerm 标签页内运行！
"""
import subprocess
import shutil
import sys

wezterm = shutil.which("wezterm") or shutil.which("wezterm.exe")
if not wezterm:
    wezterm = "C:\\Program Files\\WezTerm\\wezterm.exe"

print(f"[INFO] WezTerm: {wezterm}")
print()

# 测试 1: list 命令
print("=== 测试 1: wezterm cli list ===")
try:
    result = subprocess.run(
        [wezterm, "cli", "list"],
        capture_output=True,
        text=True,
        encoding='utf-8',
        errors='ignore',
        timeout=3
    )
    print(f"返回码: {result.returncode}")
    if result.stdout:
        print(f"输出:\n{result.stdout[:500]}")
    if result.stderr:
        print(f"错误:\n{result.stderr[:500]}")
except subprocess.TimeoutExpired:
    print("[ERROR] 命令超时")
except Exception as e:
    print(f"[ERROR] {e}")

print()

# 测试 2: send-text 命令
print("=== 测试 2: wezterm cli send-text ===")
print("尝试向 pane 0 发送测试消息...")
try:
    result = subprocess.run(
        [wezterm, "cli", "send-text", "--pane-id", "0", "--no-paste", "echo 'test'\n"],
        capture_output=True,
        text=True,
        encoding='utf-8',
        errors='ignore',
        timeout=3
    )
    print(f"返回码: {result.returncode}")
    if result.stdout:
        print(f"输出: {result.stdout}")
    if result.stderr:
        print(f"错误: {result.stderr}")
    
    if result.returncode == 0:
        print("[OK] 发送成功！检查 pane 0 是否收到 'echo test'")
    else:
        print("[FAIL] 发送失败")
        
except subprocess.TimeoutExpired:
    print("[ERROR] 命令超时 - 这通常意味着 WezTerm CLI 无法连接")
    print("       请确保在 WezTerm 标签页内运行此脚本！")
except Exception as e:
    print(f"[ERROR] {e}")

print()
print("=" * 60)
print("诊断结果:")
print("- 如果测试 1 成功但测试 2 超时，可能是 send-text 的问题")
print("- 如果两个都失败，说明不在 WezTerm 环境内运行")
print("- 解决方案：必须在 WezTerm 的某个标签页里运行此脚本")
print("=" * 60)
