# MMA-AI Ralph Harness (Operational Contract)

Goal:
- Create a REPRODUCIBLE backtest/evaluation command that produces stable metrics from repo data.
- Then iteratively improve model quality without regressions.

Hard constraints:
- No data leakage: never train on fights after the prediction date.
- Time-based split only (walk-forward or chronological holdout).
- Evaluation must be automated by a single command, and must write JSON metrics to disk.

Primary metric (minimize):
- logloss

Guardrails:
- Brier should not worsen meaningfully
- AUC should not collapse
- If changing evaluation protocol, document it and freeze a new baseline (never silently change)

Artifacts:
- ralph/baselines/metrics.json    (frozen baseline)
- ralph/results/iter_metrics.json (latest iteration)
- ralph/logs/audit.md             (initial audit + discovered commands/data)
- ralph/logs/iter_<N>.md          (one-change-per-iteration log)
