\
You are Claude Code running in a local repo. Your job: analyze and improve an existing MMA XGBoost model, then verify the improvement with a local backtest.

Project context:
- Repo: this working directory
- Target model: `Models/model-xgboost-1.1`
- Data is already inside the repo (do not download anything from the internet).

Rules:
- Prefer minimal changes. Make the smallest improvement that actually helps.
- Avoid data leakage/slippage. If the dataset is time-ordered (fight date), use chronological splits.
- Do not delete user data. Do not rewrite large parts of the project unless necessary.
- Always run commands you change or add, and fix errors you introduce.

Steps:
1) Read `RALPH_PLAN.md` if it exists (from plan mode). If it does not exist, quickly infer:
   - how to train
   - how to evaluate/backtest
   - where the data lives
2) Establish a baseline:
   - Run the existing training/evaluation (or create and run ONE minimal backtest runner if missing).
   - Record baseline metrics (log loss and/or Brier score; calibration if feasible).
3) Check for leakage/slippage:
   - Ensure the split strategy does not leak future fights into training.
   - Ensure fight-level grouping is respected (no same fight in train and test).
4) Implement 1–3 improvements:
   - Prioritize: better split, early stopping, reasonable regularization, feature leakage fixes, calibration.
5) Re-run backtest and compare to baseline.
6) Write results:
   - Create/update `reports/ralph_xgb_report.md` with:
     - baseline vs improved metrics
     - what changed
     - how to run the backtest
     - any remaining risks/assumptions

Completion criteria:
- Backtest runs successfully.
- Metrics are not worse than baseline (ideally improved).
- You wrote `reports/ralph_xgb_report.md` with clear reproduction commands.

End your final response with exactly: <promise>DONE</promise>
