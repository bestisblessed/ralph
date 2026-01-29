#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-iter}"

python ralph/code/backtest_runner.py "$MODE"
