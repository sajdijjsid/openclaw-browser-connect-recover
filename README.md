# openclaw-browser-recover

A small, practical recovery playbook for OpenClaw browser-control flakiness (timeouts / MCP connection drops / 9222 conflicts).

This repo packages the workflow as an OpenClaw **skill** so you can reuse it consistently.

## What problem this solves
When controlling a browser via OpenClaw, you may hit:

- `browser` tool: **timed out. Restart the OpenClaw gateway**
- `McpError: Connection closed`
- Port conflicts: **9222 already in use** (Chrome CDP)

This skill standardizes the recovery sequence so you don’t spam retries or randomly restart things.

## When to use
Use this skill when you see any of the following symptoms:

- `browser.status / browser.tabs / browser.snapshot` time out
- `MCP Connection closed` during snapshot/click/type
- You can list tabs but cannot snapshot
- You want to switch between `profile=user` and `profile=openclaw` but **9222 is occupied**

## Quick start
Copy the skill folder into your OpenClaw workspace:

```bash
cp -r skill/openclaw-browser-recover ~/.openclaw/workspace/skills/
```

(Optional) run the healthcheck script:

```bash
bash ~/.openclaw/workspace/skills/openclaw-browser-recover/scripts/healthcheck.sh
```

## Safety principles
- **Do not spam browser tool retries** after a timeout.
- Prefer: **wait → verify ports → restart gateway (once) → ask user to restart Chrome**.
- Avoid `stop && start` unless explicitly requested.

## License
MIT
