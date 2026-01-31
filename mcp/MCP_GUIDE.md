# MCP Integration Guide

## Overview

This project automatically configures MCP (Model Context Protocol) server for inter-instance communication. Each time you run `python run.py`, it updates the project's Claude configuration with the MCP server path.

## How It Works

1. **Automatic Configuration**: When you run `python run.py`, it:
   - Creates/updates `.claude/config.json` in the project directory
   - Adds/updates `mcpServers.send-tool` entry with the absolute path to the MCP server
   - No manual editing required

2. **MCP Server**: Located at `mcp/send-tool/server.py`
   - Provides `send_message` tool to Claude instances
   - Includes integrated `send.py` script for message routing
   - Full Unicode support (Chinese, emoji, and all international characters)

3. **Usage in Claude**: Just use the simple syntax:
   ```
   send ui "Design the homepage"
   send coder "Implement the API"
   send test "Run integration tests"
   ```

## Configuration File Example

After running `python run.py`, your `.claude/config.json` will contain:

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

## Testing

1. **Run the Launcher** (in WezTerm):

   ```bash
   python run.py
   ```

   Expected output:

   ```
   [+] MCP server configured: .claude/config.json
   [+] Server path: E:\ai_project\claude-multi-worker\mcp\send-tool\server.py
   ```

2. **Test MCP Tool** (in any Claude instance):

   ```
   send ui "hello"
   ```

   Claude should respond with confirmation and use the `send_message` tool.

## Features

- **Fast**: Direct stdio communication with MCP protocol
- **Natural**: Simple `send <instance> "<message>"` syntax
- **Automatic**: Path configured automatically per project
- **Cross-platform**: Works on Windows/macOS/Linux
- **Unicode**: Full support for Chinese, emoji, and all international characters

## Troubleshooting

### MCP Configuration Failed

If you see `[!] Failed to configure MCP server`, check:
- Python has write permissions to the project directory
- The `.claude` directory can be created

### Tool Not Available in Claude

1. Restart Claude instance
2. Check config file: `cat .claude/config.json`
3. Verify MCP server path is absolute and correct

### Message Not Delivered

1. Check tab mapping exists: `.cmw_config/tab_mapping.json`
2. Verify target instance is running
3. Check instance ID is correct (case-sensitive)

## Manual Configuration (Not Recommended)

If automatic configuration doesn't work, manually edit `.claude/config.json`:

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
