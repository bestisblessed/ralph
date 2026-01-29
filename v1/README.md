\
# Ralph Wiggum loop (minimal) using Claude Code CLI

This is a tiny "Ralph Wiggum" loop: feed Claude Code a prompt repeatedly until a completion token appears.

## Prereqs
1) Install Claude Code CLI and log in once.
   - Official docs: `claude` is the CLI, and `claude -p` runs in non-interactive "print" mode.
   - Install options include Homebrew `brew install --cask claude-code` or the install script `curl -fsSL https://claude.ai/install.sh | bash`.

2) Run from your repo root (example: `~/Code/mma-ai`).

## Quick start (2 steps)
From your repo root:

```bash
# 1) (optional) plan once
./loop.sh plan 1

# 2) build for a few iterations
./loop.sh 5
```

Or skip planning and just build:

```bash
./loop.sh 2
```

## Useful knobs
```bash
# choose a model alias
CLAUDE_MODEL=opus ./loop.sh 3

# simpler output (recommended for token detection)
OUTPUT_FORMAT=text ./loop.sh 5

# guardrails for cost / runaway agent loops
MAX_TURNS=12 MAX_BUDGET_USD=5.00 ./loop.sh 5
```

Logs are written to: `.ralph-logs/`

## Files
- `loop.sh`              : loop runner
- `PROMPT_plan.md`       : optional planning prompt (writes `RALPH_PLAN.md`)
- `PROMPT_build.md`      : build/improve prompt (writes `reports/ralph_xgb_report.md`)
