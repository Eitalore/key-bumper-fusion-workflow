#!/usr/bin/env python3
"""Validate key-bumper-fusion-workflow before OpenSCAD export."""
from __future__ import annotations

import csv
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCAD_DIR = ROOT / "models" / "openscad"
PARAM_DIR = ROOT / "models" / "parameters"

MODELS = {
    "geely_ex2": "geely_ex2_bumper_canivete_v02.scad",
    "geely_ex2_bosl2": "geely_ex2_bumper_bosl2_v01.scad",
    "byd_dolphin": "byd_dolphin_bumper_canivete_v02.scad",
    "byd_yuan_pro": "byd_yuan_pro_bumper_v01.scad",
    "byd_seal": "byd_seal_bumper_v01.scad",
}

REQUIRED_COMMON = ["KEY_L", "KEY_W", "KEY_T", "KEY_R"]
REQUIRED_SLOT = {
    "geely_ex2": ["BLADE_SLOT_SIDE", "BLADE_SLOT_X", "BLADE_SLOT_W", "BLADE_SLOT_Z", "BLADE_SLOT_H"],
    "geely_ex2_bosl2": ["BLADE_SLOT_SIDE", "BLADE_SLOT_X", "BLADE_SLOT_W", "BLADE_SLOT_Z", "BLADE_SLOT_H"],
    "byd_dolphin": ["BLADE_SLOT_SIDE", "BLADE_SLOT_X", "BLADE_SLOT_W", "BLADE_SLOT_Z", "BLADE_SLOT_H"],
    "byd_yuan_pro": ["MECH_SLOT_SIDE", "MECH_SLOT_X", "MECH_SLOT_L", "MECH_SLOT_Z", "MECH_SLOT_H"],
    "byd_seal": ["MECH_SLOT_SIDE", "MECH_SLOT_X", "MECH_SLOT_L", "MECH_SLOT_Z", "MECH_SLOT_H"],
}


def balanced(text: str, left: str, right: str) -> bool:
    return text.count(left) == text.count(right)


def validate_scad(name: str, path: Path) -> list[str]:
    errors: list[str] = []
    if not path.exists():
        return [f"{name}: missing {path.name}"]
    text = path.read_text(encoding="utf-8")
    for param in REQUIRED_COMMON + REQUIRED_SLOT[name]:
        if not re.search(rf"\b{re.escape(param)}\s*=", text):
            errors.append(f"{name}: missing parameter {param}")
    for left, right in [("{", "}"), ("(", ")"), ("[", "]")]:
        if not balanced(text, left, right):
            errors.append(f"{name}: unbalanced delimiters {left}{right}")
    if name == "geely_ex2_bosl2" and "include <BOSL2/std.scad>;" not in text:
        errors.append("geely_ex2_bosl2: missing BOSL2 include")
    return errors


def validate_csv(path: Path) -> list[str]:
    errors: list[str] = []
    if not path.exists():
        return [f"missing parameter file {path.name}"]
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    names = {row.get("name") for row in rows}
    for param in REQUIRED_COMMON:
        if param not in names:
            errors.append(f"{path.name}: missing CSV parameter {param}")
    return errors


def main() -> int:
    errors: list[str] = []
    for name, filename in MODELS.items():
        errors.extend(validate_scad(name, SCAD_DIR / filename))
    for model in ("geely_ex2", "byd_dolphin", "byd_yuan_pro", "byd_seal"):
        errors.extend(validate_csv(PARAM_DIR / f"{model}.csv"))
    if errors:
        print("VALIDATION FAILED")
        print("\n".join(f"- {error}" for error in errors))
        return 1
    print(f"VALIDATION OK: {len(MODELS)} SCAD models and 4 parameter CSV files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
