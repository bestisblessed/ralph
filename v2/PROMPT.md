You are operating in a Ralph outer loop inside the MMA-AI repo.

Read: ralph/AGENTS.md and ralph/config.yaml.

PHASE 1 (must complete before improvements):
A) Repo discovery + audit:
   - Identify how data is stored/loaded (file paths, formats, schemas).
   - Identify existing training/prediction code paths (modules, scripts, functions).
   - Identify where the XGBoost-1.1 / RF / LR options live.
   - Identify likely leakage/slippage risks (feature availability vs fight_date).
   - Write findings to: ralph/logs/audit.md (include exact file paths and commands discovered).
B) Build a working automated backtest:
   - Implement ralph/code/backtest_runner.py so that:
     - It runs a chronological backtest (walk-forward preferred; else chronological holdout).
     - It outputs probability predictions and computes:
       logloss, brier, auc.
     - It writes metrics JSON to ralph/baselines/metrics.json for baseline mode and
       ralph/results/iter_metrics.json for iter mode.
     - It is reproducible (seeded) and does not use future data.
   - Ensure `./ralph/run_eval.sh baseline` runs successfully end-to-end.
   - Freeze baseline by committing it.

PHASE 2 (iterations, max 100 loops total):
For each iteration:
1) Choose exactly ONE improvement (bug fix, leakage fix, feature engineering, calibration, hyperparams, split refinement).
2) Implement it.
3) Run `./ralph/run_eval.sh iter`.
4) Compare iter metrics to baseline metrics:
   - Accept only if logloss improves AND guardrails acceptable.
   - If not improved, revert code changes (keep repo non-regressed).
5) Log every attempt to ralph/logs/iter_<N>.md:
   - What changed
   - Why
   - Metrics before/after
   - Keep/revert decision
6) Commit only accepted improvements.

Stop condition:
- After 3 accepted improvements in a row OR no high-quality improvements remain, print EXACTLY: DONE

Rules:
- Do NOT ask the user questions.
- If anything is ambiguous, choose the most conservative, leakage-safe approach and document assumptions in audit.md.
- Keep the evaluation protocol stable once baseline is frozen (unless a correctness issue forces change; then document and reset baseline explicitly).
