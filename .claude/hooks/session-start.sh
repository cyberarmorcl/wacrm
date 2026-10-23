#!/bin/bash
# Installs playwright-cli in Claude Code cloud sessions and points it at the
# Chromium that ships with the container (its default build isn't installed).
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

if ! command -v playwright-cli >/dev/null 2>&1; then
  npm install -g @playwright/cli@0.1.22 >/dev/null
fi

if [ -x /opt/pw-browsers/chromium ]; then
  mkdir -p "$CLAUDE_PROJECT_DIR/.playwright"
  cat > "$CLAUDE_PROJECT_DIR/.playwright/cli.config.json" <<'JSON'
{
  "browser": {
    "browserName": "chromium",
    "launchOptions": {
      "executablePath": "/opt/pw-browsers/chromium",
      "args": ["--no-sandbox"]
    }
  }
}
JSON
fi
