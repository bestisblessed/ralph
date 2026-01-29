\
You are Claude Code running in a local repo. Your job is to produce a minimal, verifiable plan to evaluate and improve an existing MMA XGBoost model.

Project context:
- Repo: this working directory
- Target model: `Models/model-xgboost-1.1`
- Data is already inside the repo (do not download anything from the internet).

Plan requirements:
1) Identify the EXACT entrypoint(s) for training and for evaluation/backtesting.
   - If a backtest script does not exist, propose creating ONE minimal backtest runner (a single python file) that can be executed locally.
2) Define an evaluation setup that avoids data leakage/slippage:
   - If fights have dates, use chronological splits (train on past, test on future).
   - If there are multiple rows per fight or fighter, ensure splits don't leak fight-level info.
3) Define metrics appropriate for odds/probability prediction (e.g., log loss, Brier score, calibration, AUC).
4) List the exact shell commands you will run in build mode (venv, installs, python commands, etc.).
5) Specify 1–3 high-confidence improvements to try first (hyperparams, early stopping, regularization, time-based splitting, calibration, feature leakage checks).

Output:
- Write `RALPH_PLAN.md` at the repo root with the plan, commands, and file paths.
- End your final response with exactly: <promise>PLAN</promise>
