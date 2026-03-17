---
name: openclaw-browser-recover
description: "Diagnose and recover OpenClaw browser tool failures (timeout / MCP Connection closed) involving gateway ports 18789/18791 and Chrome CDP 9222 conflicts. Use when browser tool says timed out/restart gateway, MCP Connection closed, port 9222 in use, cannot start openclaw profile, or user asks to fix browser control / reconnect / cannot snapshot." 
---

# OpenClaw Browser Recover

目标：在 **不瞎重试** 的前提下，快速恢复 OpenClaw `browser` 工具可用性，并给出**最短**下一步动作。

## 术语速记
- **18789**：OpenClaw gateway 主端口
- **18791**：browser-control 子服务端口（browser 工具依赖它）
- **9222**：Chrome CDP 远程调试端口（`profile="user"` 需要；`profile="openclaw"` 也常用它）

## 典型故障与含义

### A) `browser ... timed out. Restart the OpenClaw gateway. Do NOT retry`
说明：browser-control 链路卡死。继续调用 `browser.*` 只会重复失败。

### B) `McpError: Connection closed`
说明：控制通道在运行中断开。常见于 Chrome 崩溃/挂起、或 attach 会话不稳定。

### C) `PortInUseError: Port 9222 is already in use`
说明：你想启动 openclaw profile，但本机 Chrome 已占用 9222（或反之）。同一时间只能一个实例占用该端口，除非你做端口改造。

---

# 标准恢复流程（按顺序，做到哪步好就停）

## Step 0 — 先等 20–30 秒
很多卡顿会自愈。等待期间不要刷 browser 工具。

## Step 1 — 端口与服务体检（exec）
运行：
```bash
openclaw gateway status
ss -lntp | egrep '(:18789|:18791|:9222)' || true
```
判读：
- 18789/18791 不在：gateway/browser-control 侧异常 → 进入 Step 3（重启 gateway）。
- 9222 不在：`profile=user` 无法用 → 让用户打开带 9222 的 Chrome，或改用 openclaw profile。

## Step 2 — 最小 browser 探测
依次调用（只探测一次）：
- `browser.status profile="user"`
- `browser.tabs profile="user" limit=5`

若 OK：恢复完成。

若仍 timeout / connection closed：进入 Step 3。

## Step 3 — 最短修复动作
### 3A) 只做一次 gateway 重启
执行：
- `openclaw gateway restart`

然后等待 3–5 秒，再回到 Step 2。

### 3B) 仍然 `Connection closed`
让用户做这一句话动作（最有效）：
- **完全退出 Chrome** → 重新打开 Chrome → 再试 `browser.status profile=user`

### 3C) 需要 openclaw profile，但 9222 被占
- 让用户关掉占用 9222 的 Chrome，或改用 `profile=user`。

> 同一轮最多一次 restart；不要 stop+start 连击，除非用户明确要求。

---

# 给用户的“下一步一句话”模板（直接复制发）

- 9222 不在：
  - “请先打开带 9222 的 Chrome（或把页面截图/文字发我），我才能接管浏览器。”

- browser timeout：
  - “browser-control 卡住了：请执行 `openclaw gateway restart`，我再继续。”

- Connection closed：
  - “控制通道断开：请把 Chrome 完全退出再重开，然后回我‘Chrome 重开了’。”

---

# 附：一键体检脚本
```bash
bash skills/openclaw-browser-recover/scripts/healthcheck.sh
```
