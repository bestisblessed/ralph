# Ralph MMA-AI Harness (No Plugin)

This zip contains a complete "Ralph Wiggum" outer-loop harness you can drop into ANY repo (e.g., your MMA-AI project).
It forces the agent to:
1) Discover your repo’s data/training/prediction pipeline
2) Build an automated chronological backtest command
3) Freeze a baseline
4) Run iterative improvements up to N iterations with regression guards

## Prereqs
- You have a working AI coding CLI installed and logged in (default in scripts: `claude`).
  - Replace `claude -p` in `ralph/loop.sh` with `codex`, `opencode`, etc if you prefer.

## Install into your project
From your project root (example: ~/Code/mma-ai):

```bash
# 1) Unzip this archive somewhere, then copy the ralph/ folder into your repo root
cp -R /path/to/unzipped/ralph ./ralph

# 2) Make scripts executable
chmod +x ralph/loop.sh ralph/run_eval.sh

# 3) (Recommended) Create a git branch
git checkout -b ralph-backtest-harness

# 4) Start the loop (caps at 100 iterations)
./ralph/loop.sh 100
```

## What you’ll see
- `ralph/logs/audit.md` (first: discovery + leakage audit)
- `ralph/logs/iter_<N>.md` (each attempt logged)
- `ralph/baselines/metrics.json` (frozen baseline once implemented)
- `ralph/results/iter_metrics.json` (latest metrics)

## Important
This harness intentionally ships with an UNIMPLEMENTED backtest runner:
- `ralph/code/backtest_runner.py`

The agent’s first job is to implement it based on your repo.
