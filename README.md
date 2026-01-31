# Claude Multi Worker

![Project Example](images/example.png)

[中文文档](README_CN.md) | English

Multi-instance Claude CLI launcher and communication tool. Run multiple independent Claude instances simultaneously in WezTerm for AI assistant collaboration.

## 📋 Prerequisites

Before using this tool, ensure you have:

1. **Python 3.10+** - Check version: `python --version`
2. **WezTerm** - Check if installed: `wezterm --version`
   - If not installed, visit: https://wezterm.org/index.html
3. **Claude CLI** - Check if installed: `claude --version`

## ✨ Core Features

- 🚀 **Multi-Instance Launch** - Start multiple Claude instances in WezTerm tabs with one command
- 💬 **Instance Communication** - Send messages between instances using MCP tools or command line
- 🌐 **Unicode Support** - Full support for Chinese, emoji, and all international characters
- ⚡️ **Flexible Configuration** - Customize instance count and roles via `cmw.config`
- 📍 **Auto Mapping** - Automatically save instance-to-tab mappings

## 🚀 Quick Start

### 1. Configure Instances

Edit `cmw.config` to define your instances:

```json
{
  "providers": ["claude"],
  "flags": {
    "claudeArgs": ["--dangerously-skip-permissions"]
  },
  "claude": {
    "instances": [
      { "id": "default", "role": "general coordinator", "autostart": true },
      { "id": "ui", "role": "UI/UX designer", "autostart": true },
      { "id": "coder", "role": "developer", "autostart": true },
      { "id": "test", "role": "QA engineer", "autostart": true }
    ]
  }
}
```

### 2. Launch Instances

**Run in WezTerm terminal:**

```bash
python run.py
```

The script will automatically:

- Read configuration from `cmw.config`
- **Configure MCP server** for inter-instance communication
- Launch all instances with `autostart: true`
- Create multiple WezTerm tabs
- Start a Claude instance in each tab
- Save mappings to `.cmw_config/tab_mapping.json`

### 3. Send Messages Between Instances

After running `python run.py`, the MCP server is automatically configured. You can send messages to other instances directly from Claude:

```
send ui "Design the login page"
send coder "Implement user authentication"
send test "Verify the login flow"
```

**Features:**
- Full Unicode support (Chinese, emoji, and all international characters work perfectly)
- Simple syntax: `send <instance> "<message>"`
- The MCP server configuration is automatically updated each time you run `python run.py`

## 💡 Usage Example

### Typical Workflow

```
# 1. In default instance, assign tasks:
send ui "Design a modern dashboard interface"
send coder "Implement data visualization components"
send test "Write unit tests"

# 2. In ui instance, after design complete:
send coder "UI design complete, files in /designs directory"

# 3. In coder instance, after development complete:
send test "Feature implemented, please start testing"

# 4. In test instance, after testing complete:
send default "All tests passed, ready for release"
```

## 📂 Project Structure

```
claude-multi-worker/
├── .cmw_config/
│   ├── tab_mapping.json        # Tab mappings (auto-generated)
│   └── .claude-*-session       # Session files for each instance
├── lib/                        # Core library files
├── mcp/
│   └── send-tool/
│       ├── server.py           # MCP server
│       ├── send.py             # Send script (integrated)
│       ├── server.json         # MCP metadata
│       └── README.md           # MCP documentation
├── cmw.config                  # Instance configuration
├── run.py                      # Launch script
├── README.md                   # This document
└── README_CN.md                # Chinese documentation
```

## ⚙️ Configuration Options

### Instance Configuration

- `id` - Instance identifier (used in send command)
- `role` - Role description (system prompt)
- `autostart` - Whether to auto-start this instance

**Supports 1-12 instances**, recommend 3-5 for optimal collaboration.

### Custom Instances

Modify `cmw.config` based on your needs:

```json
{
  "claude": {
    "instances": [
      { "id": "architect", "role": "System Architect", "autostart": true },
      { "id": "frontend", "role": "Frontend Developer", "autostart": true },
      { "id": "backend", "role": "Backend Developer", "autostart": true },
      { "id": "devops", "role": "DevOps Engineer", "autostart": true }
    ]
  }
}
```

### Mapping File

Auto-generated at `.cmw_config/tab_mapping.json`:

```json
{
  "work_dir": "/path/to/project",
  "tabs": {
    "default": { "pane_id": "0", "role": "general coordinator" },
    "ui": { "pane_id": "1", "role": "UI/UX designer" },
    "coder": { "pane_id": "2", "role": "developer" },
    "test": { "pane_id": "3", "role": "QA engineer" }
  },
  "created_at": 1234567890.123
}
```

The MCP `send_message` tool reads pane IDs from this file to route messages to specific tabs.

## 🚨 Troubleshooting

### Launch Failure

1. Confirm running in **WezTerm** terminal
2. Verify Claude CLI is installed: `claude --version`

### Message Send Failure

1. Confirm mapping file exists: `.cmw_config/tab_mapping.json`
2. Restart instances to refresh mappings
3. Check instance ID is correct (case-sensitive)
4. **Disable Claude Skills conflicts**: If you have custom skills like `ask`, `send`, or `ping` in your Claude configuration, they may conflict with this project's MCP tools. Remove or rename conflicting skills in `~/.config/claude/config.json`

### WezTerm Detection Failure

Ensure `wezterm` is in PATH:

```bash
wezterm --version
```

## 💡 Use Cases

- **Team Collaboration Simulation** - Assign different roles (frontend, backend, testing, etc.)
- **Task Decomposition** - Break complex projects into specialized instances
- **Code Review** - One instance writes code, another reviews
- **Learning Assistant** - One instance explains, another asks questions

## 📝 Notes

- Must run `python run.py` in WezTerm terminal
- Use `send <instance> "<message>"` for communication
- Each tab contains one Claude instance with a unique pane ID
- Each instance maintains independent session files
- Mapping file is auto-generated on each launch
- Use `Ctrl+C` to exit an instance
- Supports c1-c12 shorthand: `send c1 "message"`

## 📄 License

See [LICENSE](LICENSE) file for details.

---

## 📦 Version History

### v1.0.2 (2026-02-01)

**Documentation:**

- Updated README with simplified `send <instance> "<message>"` syntax
- Added clarification about automatic MCP server configuration
- Removed outdated command-line examples
- Removed known limitation about Chinese character support (now fully fixed)
- Updated project structure to reflect `mcp/send-tool/` directory

**Code Improvements:**

- Added `CMW_VERBOSE` environment variable for debug output control
- Replaced hardcoded DEBUG prints with `debug_print()` function
- Removed duplicate exception handling code
- Added `pyproject.toml` for proper package management
- Moved `send` script into `mcp/send-tool/` for self-contained MCP package

**Features:**

- MCP server now fully self-contained and ready for registry publication

### v1.0.1 (2026-01-30)

**Bug Fixes:**

- Fixed message submission reliability issue where text was sent but not automatically submitted
- Improved handling of long messages (>100 characters) by adding 2-second delay and empty string trigger
- Optimized message delivery timing to prevent race conditions between text input and Enter key

**Changes:**

- Message sending now uses command-line argument mode for better reliability
- Added special handling for long text messages to ensure proper submission
- Enhanced cross-platform compatibility for message submission
