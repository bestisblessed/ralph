#!/usr/bin/env bash
set -euo pipefail

MAX_ITERS="${1:-100}"
ITER=0

# Swap this if you prefer another CLI:
#   AGENT_CMD='codex -q' or 'opencode -p' etc.
AGENT_CMD='claude -p'

mkdir -p ralph/logs ralph/results ralph/baselines

while true; do
  ITER=$((ITER+1))
  if [[ "$ITER" -gt "$MAX_ITERS" ]]; then
    echo "Reached max iterations ($MAX_ITERS). Stopping."
    exit 0
  fi

  echo "===== RALPH ITERATION $ITER / $MAX_ITERS ====="
  echo "$ITER" > ralph/ITERATION.txt

  OUT_FILE="ralph/logs/agent_out_${ITER}.txt"
  set +e
  cat ralph/PROMPT.md | eval "$AGENT_CMD" | tee "$OUT_FILE"
  STATUS=${PIPESTATUS[0]}
  set -e

  if [[ "$STATUS" -ne 0 ]]; then
    echo "[warn] agent exited nonzero ($STATUS); continuing..."
  fi

  if grep -q "^DONE$" "$OUT_FILE"; then
    echo "Agent signaled DONE. Stopping."
    exit 0
  fi

  echo
done
