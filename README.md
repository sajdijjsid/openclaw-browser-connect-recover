# OpenClaw Browser Recover (Skill)

A practical OpenClaw **skill** that helps you recover when the `browser` tool gets flaky:

- `timed out. Restart the OpenClaw gateway` (and repeating calls keeps failing)
- `McpError: Connection closed`
- `Port 9222 is already in use` (Chrome CDP conflict)

This repo packages a **minimal, repeatable recovery SOP** so you stop guessing and stop spamming retries.

## When to use
Use this skill when you see any of these:

- `browser.status / browser.tabs / browser.snapshot` time out
- Snapshots/clicks fail with **Connection closed**
- Tabs list works but snapshot doesn’t
- You need to reason about **18789 / 18791 / 9222** and which side is broken

## Install (copy into your OpenClaw workspace)

### Option A — git clone (recommended)
```bash
git clone https://github.com/sajdijjsid/openclaw-browser-connect-recover.git
cp -r openclaw-browser-connect-recover/skill/openclaw-browser-connect-recover ~/.openclaw/workspace/skills/
```

### Option B — download ZIP (no git)
1. Download: <https://github.com/sajdijjsid/openclaw-browser-connect-recover/archive/refs/heads/main.zip>
2. Unzip it, then copy:
```bash
cp -r openclaw-browser-connect-recover-main/skill/openclaw-browser-connect-recover ~/.openclaw/workspace/skills/
```

## What you get
- `skills/openclaw-browser-connect-recover/SKILL.md`: the SOP
- `skills/openclaw-browser-connect-recover/scripts/healthcheck.sh`: one-shot port/gateway check

Run healthcheck:
```bash
bash ~/.openclaw/workspace/skills/openclaw-browser-connect-recover/scripts/healthcheck.sh
```

## Workflow (short version)
1) Wait 20–30s (many cases self-heal)
2) Check ports: 18789 / 18791 / 9222
3) Probe `browser.status(profile="user")` once
4) If still broken: restart gateway **once**
5) If still `Connection closed`: restart Chrome (full quit) and retry

## License
MIT
