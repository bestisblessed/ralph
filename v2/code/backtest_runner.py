"""
Ralph backtest runner scaffold.

The agent must:
- Discover how this repo loads data and trains/predicts.
- Implement a chronological backtest here (or call existing internal functions).
- Output JSON metrics to the paths in ralph/config.yaml.

Notes:
- Prefer walk-forward evaluation with a time-based split.
- Ensure no future leakage (train only on fights strictly before the prediction date).
- Output should be stable/reproducible (seed everything).
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict

import yaml


def load_config() -> dict:
    cfg_path = Path("ralph/config.yaml")
    if not cfg_path.exists():
        raise FileNotFoundError("ralph/config.yaml not found")
    return yaml.safe_load(cfg_path.read_text())


def write_json(path: str, payload: dict) -> None:
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(payload, indent=2, sort_keys=True))


def main(mode: str) -> int:
    cfg = load_config()
    out_key = "baseline_metrics" if mode == "baseline" else "iter_metrics"
    out_path = cfg["output"][out_key]

    # TODO (Agent must implement):
    # 1) Discover data source(s) and load into memory
    # 2) Build time-based split (walk-forward preferred)
    # 3) Train model(s) and predict probabilities for each fold/window
    # 4) Compute metrics: logloss, brier, auc
    # 5) Write metrics JSON to out_path, including:
    #    - metric values
    #    - dataset/version identifiers if available
    #    - split parameters used

    raise SystemExit(
        "Not implemented yet. Agent must implement ralph/code/backtest_runner.py based on repo."
    )

    # Example output shape (fill in real values):
    # metrics = {
    #   "logloss": 0.0,
    #   "brier": 0.0,
    #   "auc": 0.0,
    #   "notes": "walk-forward; seed=1337; no leakage"
    # }
    # write_json(out_path, metrics)
    # return 0


if __name__ == "__main__":
    import sys

    mode = sys.argv[1] if len(sys.argv) > 1 else "iter"
    raise SystemExit(main(mode))
