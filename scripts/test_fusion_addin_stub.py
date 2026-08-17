#!/usr/bin/env python3
"""Offline smoke test for the Fusion add-in's CSV parameter path."""
from __future__ import annotations

import importlib.util
import sys
import tempfile
import types
from pathlib import Path

class FakeValueInput:
    @staticmethod
    def createByReal(value):
        return value

class FakeUserParameter:
    def __init__(self, name, value, units, comment):
        self.name = name
        self.value = value
        self.units = units
        self.comment = comment
        self.expression = str(value)

class FakeUserParameters:
    def __init__(self):
        self.items = {}
    def itemByName(self, name):
        return self.items.get(name)
    def add(self, name, value, units, comment):
        self.items[name] = FakeUserParameter(name, value, units, comment)
        return self.items[name]

class FakeAttributes:
    def __init__(self):
        self.items = {}
    def add(self, group, name, value):
        self.items[(group, name)] = value

class FakeDesign:
    def __init__(self):
        self.userParameters = FakeUserParameters()
        self.attributes = FakeAttributes()

adsk = types.ModuleType("adsk")
core = types.ModuleType("adsk.core")
fusion = types.ModuleType("adsk.fusion")
class FakeApp:
    userInterface = types.SimpleNamespace()

core.Application = types.SimpleNamespace(get=lambda: FakeApp())
core.ValueInput = FakeValueInput
core.CommandCreatedEventHandler = type("CommandCreatedEventHandler", (), {"__init__": lambda self: None})
core.CommandEventHandler = type("CommandEventHandler", (), {"__init__": lambda self: None})
fusion.Design = types.SimpleNamespace(cast=lambda value: value)
adsk.core = core
adsk.fusion = fusion
sys.modules["adsk"] = adsk
sys.modules["adsk.core"] = core
sys.modules["adsk.fusion"] = fusion

module_path = Path(__file__).resolve().parents[1] / "fusion_addin/KeyBumperSync.bundle/Contents/KeyBumperSync.py"
spec = importlib.util.spec_from_file_location("key_bumper_sync", module_path)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

csv_path = Path(__file__).resolve().parents[1] / "models/parameters/geely_ex2.csv"
design = FakeDesign()
loaded = module._load_parameters(str(csv_path), design)
assert loaded >= 10, loaded
assert "KEY_L" in design.userParameters.items
assert "KEY_T" in design.userParameters.items
assert ("KeyBumperSync", "KEYRING_EAR_ENABLE") in design.attributes.items
print(f"FUSION ADD-IN CSV SMOKE TEST OK: {loaded} rows loaded")
