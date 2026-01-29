\
#!/usr/bin/env bash
# Ralph Wiggum loop (minimal) for Claude Code CLI
# Usage:
#   ./loop.sh                 # build mode, unlimited iterations
#   ./loop.sh 5               # build mode, max 5 iterations
#   ./loop.sh plan            # plan mode, unlimited iterations
#   ./loop.sh plan 1          # plan mode, max 1 iteration
#
# Env overrides:
#   CLAUDE_MODEL=sonnet|opus
#   OUTPUT_FORMAT=text|json|stream-json
#   MAX_TURNS=10
#   MAX_BUDGET_USD=5.00

set -euo pipefail

# Resolve repo root as the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
cd "$REPO_ROOT"

# Parse args
MODE="build"
PROMPT_FILE="PROMPT_build.md"
MAX_ITERATIONS=0

if [[ "${1:-}" == "plan" ]]; then
  MODE="plan"
  PROMPT_FILE="PROMPT_plan.md"
  MAX_ITERATIONS="${2:-0}"
elif [[ "${1:-}" =~ ^[0-9]+$ ]]; then
  MODE="build"
  PROMPT_FILE="PROMPT_build.md"
  MAX_ITERATIONS="${1}"
fi

# Config
MODEL="${CLAUDE_MODEL:-sonnet}"
OUTPUT_FORMAT="${OUTPUT_FORMAT:-text}"
MAX_TURNS="${MAX_TURNS:-}"
MAX_BUDGET_USD="${MAX_BUDGET_USD:-}"
LOG_DIR=".ralph-logs"
mkdir -p "$LOG_DIR"

PROMISE_TOKEN="<promise>DONE</promise>"
if [[ "$MODE" == "plan" ]]; then
  PROMISE_TOKEN="<promise>PLAN</promise>"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Mode:         $MODE"
echo "Prompt:       $PROMPT_FILE"
echo "Model:        $MODEL"
echo "Output:       $OUTPUT_FORMAT"
if [[ -n "$MAX_TURNS" ]]; then echo "Max turns:    $MAX_TURNS"; fi
if [[ -n "$MAX_BUDGET_USD" ]]; then echo "Max budget:   \$$MAX_BUDGET_USD"; fi
if [[ "$MAX_ITERATIONS" -gt 0 ]]; then echo "Max iters:    $MAX_ITERATIONS"; fi
echo "Promise:      $PROMISE_TOKEN"
echo "Logs:         $LOG_DIR/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Requirements
if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: 'claude' CLI not found."
  echo "Install Claude Code first (see README.md)."
  exit 127
fi

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "ERROR: prompt file not found: $PROMPT_FILE"
  exit 1
fi

ITER=0
while true; do
  if [[ "$MAX_ITERATIONS" -gt 0 ]] && [[ "$ITER" -ge "$MAX_ITERATIONS" ]]; then
    echo "Reached max iterations ($MAX_ITERATIONS)."
    exit 0
  fi

  TS="$(date +"%Y%m%d-%H%M%S")"
  LOG_FILE="$LOG_DIR/${MODE}-iter-${ITER}-${TS}.log"

  echo
  echo "═══ Iteration $ITER ($MODE) ═══"
  echo "Log: $LOG_FILE"
  echo

  # Build claude args (print mode)
  CLAUDE_ARGS=( -p
    --dangerously-skip-permissions
    --output-format "$OUTPUT_FORMAT"
    --model "$MODEL"
    --verbose
  )

  if [[ -n "$MAX_TURNS" ]]; then
    CLAUDE_ARGS+=( --max-turns "$MAX_TURNS" )
  fi
  if [[ -n "$MAX_BUDGET_USD" ]]; then
    CLAUDE_ARGS+=( --max-budget-usd "$MAX_BUDGET_USD" )
  fi

  # Run Claude Code
  set +e
  cat "$PROMPT_FILE" | claude "${CLAUDE_ARGS[@]}" | tee "$LOG_FILE"
  CLAUDE_EXIT="${PIPESTATUS[1]}"
  set -e

  # Stop if completion token found in log (works best with OUTPUT_FORMAT=text)
  if grep -Fq "$PROMISE_TOKEN" "$LOG_FILE"; then
    echo
    echo "✅ Completion token detected: $PROMISE_TOKEN"
    echo "Stopping."
    exit 0
  fi

  # If Claude exits non-zero, keep looping unless max-iterations stops us.
  if [[ "$CLAUDE_EXIT" -ne 0 ]]; then
    echo
    echo "⚠️  Claude exited with code $CLAUDE_EXIT (continuing loop)."
  fi

  ITER=$((ITER + 1))
  echo
  echo "======================== LOOP $ITER ========================"
done
