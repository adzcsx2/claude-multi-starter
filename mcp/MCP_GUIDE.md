# MCP Integration Guide

## Overview

This project automatically configures MCP (Model Context Protocol) server for inter-instance communication. Each time you run `python run.py`, it updates Claude CLI configuration with the current project path.

## How It Works

1. **Automatic Configuration**: When you run `python run.py`, it:
   - Locates Claude CLI config file:
     - Windows: `C:\Users\<user>\.config\claude\config.json`
     - macOS/Linux: `~/.config/claude/config.json`
   - Adds/updates `mcpServers.send-tool` entry with absolute path to MCP server
   - No manual editing required

2. **MCP Server**: Located at `mcp/send-tool/server.py`
   - Provides `send_message` tool to Claude instances
   - Auto-detects project root directory
   - Calls the `send` script to route messages

3. **Usage in Claude**: Just ask naturally:
   ```
   "Send a message to ui: Design the homepage"
   "Tell coder to implement the API"
   "Ask test to run integration tests"
   ```

## Configuration File Example

After running `python run.py`, your `~/.config/claude/config.json` will contain:

```json
{
  "mcpServers": {
    "send-tool": {
      "command": "python",
      "args": ["/absolute/path/to/claude-multi-worker/mcp/send-tool/server.py"]
    }
  }
}
```

## Testing

1. **Verify MCP Installation**:

   ```bash
   pip install mcp
   ```

2. **Run the Launcher** (in WezTerm):

   ```bash
   python run.py
   ```

   Expected output:

   ```
   [*] Configuring MCP server...
   [+] MCP server configured: C:\Users\<user>\.config\claude\config.json
   [+] Server path: E:\ai_project\claude-multi-starter\mcp\send-tool\server.py
   ```

3. **Test MCP Tool** (in any Claude instance):

   ```
   "Send a message to ui saying hello"
   ```

   Claude should respond with confirmation and use the `send_message` tool.

## Advantages Over Shell Alias

- **Fast**: No file I/O overhead (Claude doesn't need to read batch files)
- **Natural**: Use natural language instead of command syntax
- **Automatic**: Path configured automatically per project
- **Cross-platform**: Works on Windows/macOS/Linux

## Troubleshooting

### MCP Configuration Failed

If you see `[!] Warning: MCP server configuration failed`, check:

- Claude CLI is installed: `claude --version`
- Config directory exists: `~/.config/claude/` (created automatically)
- Python has write permissions to config directory

### Tool Not Available in Claude

1. Restart Claude instance
2. Check config file manually:
   ```powershell
   Get-Content ~\.config\claude\config.json
   ```
3. Verify MCP server path is absolute and correct

### Message Not Delivered

1. Check tab mapping exists: `.cmw_config/tab_mapping.json`
2. Verify target instance is running
3. Test with command line first: `python send <instance> "test"`

## Manual Configuration (Not Recommended)

If automatic configuration doesn't work, manually edit `~/.config/claude/config.json`:

```json
{
  "mcpServers": {
    "send-tool": {
      "command": "python",
      "args": ["E:\\ai_project\\claude-multi-worker\\mcp\\send-tool\\server.py"]
    }
  }
}
```

**Note**: Use absolute path and escape backslashes on Windows.
