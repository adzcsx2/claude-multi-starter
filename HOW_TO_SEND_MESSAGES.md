# 🚀 发送消息完整指南

## 当前状态检测

你有 3 个独立的 WezTerm 窗口正在运行，但它们**无法通过 wezterm cli 控制**。

## ❌ 为什么 send-tab.py 不工作？

`send-tab.py` 需要：
1. WezTerm 窗口在**同一个进程**中（使用标签页或窗格）
2. 能通过 `wezterm cli` 连接到 mux server
3. 有正确的 `pane_id` 映射

**你现在的情况**：3个独立的 WezTerm 进程 → CLI 无法连接 → 无法自动发送

---

## ✅ 解决方案：重新启动为单一 WezTerm 窗口

### 步骤 1: 关闭当前所有窗口

```powershell
Get-Process wezterm-gui -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process claude -ErrorAction SilentlyContinue | Stop-Process -Force
```

### 步骤 2: 手动启动单一 WezTerm 窗口

```powershell
# 打开 WezTerm
wezterm

# 在第一个标签页运行:
cd E:\ai_project\claude-multi-starter
claude --dangerously-skip-permissions

# 按 Ctrl+Shift+T 创建第二个标签页，运行:
cd E:\ai_project\claude-multi-starter
claude --dangerously-skip-permissions

# 再按 Ctrl+Shift+T 创建第三个标签页，运行:
cd E:\ai_project\claude-multi-starter
claude --dangerously-skip-permissions
```

### 步骤 3: 创建映射

```powershell
python fix-mapping.py
```

### 步骤 4: 测试发送消息

```powershell
# 向 c1 发送消息
python send-tab.py c1 "继续"

# 向 c2 发送消息
python send-tab.py c2 "继续"

# 向 c3 发送消息
python send-tab.py c3 "继续"
```

---

## 🎯 快速方法（如果上述太复杂）

### 使用文件通信（无需 WezTerm CLI）

在每个 Claude 窗口中手动运行相同的提示词：

**C1 窗口提示词：**
```
我是 C1 窗口，负责设计。每次执行完任务后，我会：
1. 更新 task-comms/automation-state.md
2. 将结果写入 task-comms/from-c1-design.md
3. 告诉用户"已完成，请在 C2 窗口输入'继续'"
```

**C2 窗口提示词：**
```
我是 C2 窗口，负责开发。我会：
1. 读取 task-comms/from-c1-design.md
2. 执行开发任务
3. 将结果写入 task-comms/from-c2-main.md
4. 告诉用户"已完成，请在 C3 窗口输入'继续'"
```

**C3 窗口提示词：**
```
我是 C3 窗口，负责测试。我会：
1. 读取 task-comms/from-c2-main.md
2. 执行测试任务
3. 将结果写入 task-comms/from-c3-test.md
4. 告诉用户"已完成，请在 C1 窗口输入'继续'"开始下一轮
```

然后你手动在每个窗口输入"继续"即可。

---

## 📋 总结

- **自动发送**: 需要单一 WezTerm 窗口 + 多个标签页 → 按上面步骤2-4操作
- **手动发送**: 使用文件通信 → 在每个窗口手动输入"继续"

推荐先尝试**自动发送方案**，如果遇到问题再用手动方案。
