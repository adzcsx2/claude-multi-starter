# Send Tool MCP Server

An MCP (Model Context Protocol) server for sending messages between Claude instances via WezTerm panes.

## Features

- **Send messages between Claude instances** - Directly communicate with multiple Claude instances
- **Automatic encoding handling** - Supports Chinese, emoji, and all Unicode characters
- **WezTerm integration** - Leverages WezTerm's pane system for message delivery
- **Base64 encoding** - Safely passes messages as command-line arguments

## Requirements

- **Python 3.8+**
- **WezTerm** - Must be installed and running
- **Claude Code** - Claude CLI with MCP support

## Installation

### Option 1: Install from MCP Registry (Coming Soon)

```bash
mcp install send-tool
```

### Option 2: Manual Installation

1. Clone this repository or copy the `mcp/send-tool` directory
2. Add to your Claude config (`~/.claude/config.json`):

```json
{
  "mcpServers": {
    "send-tool": {
      "command": "python",
      "args": ["/path/to/mcp/send-tool/server.py"],
      "env": {
        "PYTHONIOENCODING": "utf-8",
        "PYTHONUTF8": "1"
      }
    }
  }
}
```

## Usage

Once installed, you can use the `send_message` tool from within Claude:

```
Send "help me debug this" to instance coder
```

### Tool Parameters

- **instance** (required): Target instance ID
  - Examples: `ui`, `coder`, `test`, `default`, `c1`, `c2`, etc.
- **message** (required): Message content to send
  - Supports any characters including Chinese, emoji, etc.

## How It Works

1. MCP server receives the message via stdio
2. Message is encoded as UTF-8 and Base64
3. Python subprocess calls the `send.py` script
4. `send.py` reads configuration and delivers to the correct WezTerm pane
5. WezTerm sends the text and simulates Enter key

## Troubleshooting

### "Error: Could not load instance configuration"

Make sure you have a `.cmw_config/tab_mapping.json` file in your working directory with your instance configurations.

### "Error: wezterm command not found"

Ensure WezTerm is installed and in your PATH.

### Messages not appearing

1. Check that WezTerm is running with the correct panes
2. Verify your pane IDs in the configuration
3. Check the debug log at `mcp/send-tool/debug.log`

## License

MIT

## Contributing

Contributions welcome! Please feel free to submit a Pull Request.
