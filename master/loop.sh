#!/bin/bash

#while :; do cat PROMPT.md | claude ; done
# Can be used with other CLIs (amp, codex, opencode, etc.)

[ $# -eq 0 ] && { echo "Usage: $0 plan|<n>"; exit 1; }
if [ "$1" = "plan" ]; then
  cat PROMPT_plan.md | claude
else
  [ "$1" -gt 0 ] 2>/dev/null || { echo "Usage: $0 plan|<n>"; exit 1; }
  for ((i=0; i<$1; i++)); do cat PROMPT.md | claude; done
fi
