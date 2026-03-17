#!/usr/bin/env bash
set -euo pipefail

echo "== openclaw gateway status =="
openclaw gateway status || true

echo
echo "== ports (18789/18791/9222) =="
ss -lntp | egrep '(:18789|:18791|:9222)' || echo "no matching listeners"

echo
echo "If browser tool says timeout: openclaw gateway restart"
