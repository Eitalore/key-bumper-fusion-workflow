"""KeyBumperSync — Fusion 360 local add-in.

The add-in imports an STL produced by GitHub Actions/OpenSCAD and optionally
creates or updates Fusion user parameters from a CSV file.
"""
from __future__ import annotations

import csv
import traceback
from pathlib import Path

import adsk.core
import adsk.fusion

APP = adsk.core.Application.get()
UI = APP.userInterface
COMMAND_ID = "keyBumperSyncCommand"
COMMAND_NAME = "Key Bumper Sync"
COMMAND_DESCRIPTION = "Import a generated key-bumper STL and load measured parameters."
WORKSPACE_ID = "FusionSolidEnvironment"
PANEL_ID = "SolidCreatePanel"
_handlers = []


def _choose_file(title: str, pattern: str) -> str | None:
    dialog = UI.createFileDialog()
    dialog.title = title
    dialog.filter = pattern
    dialog.isMultiSelectEnabled = False
    result = dialog.showOpen()
    if result != adsk.core.DialogResults.DialogOK:
        return None
    return dialog.filename


def _load_parameters(csv_path: str, design: adsk.fusion.Design) -> int:
    count = 0
    with open(csv_path, newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            name = (row.get("name") or "").strip()
            raw_value = (row.get("value") or "").strip()
            units = (row.get("units") or "").strip()
            notes = (row.get("notes") or "").strip()
            if not name or not raw_value:
                continue
            if units.lower() in {"boolean", "unitless"} and raw_value.lower() in {"true", "false"}:
                # Boolean switches remain in the CSV; Fusion user parameters are
                # numerical, so keep the switch as an attribute instead.
                design.attributes.add("KeyBumperSync", name, raw_value)
                count += 1
                continue
            try:
                value = float(raw_value.replace(",", "."))
            except ValueError:
                continue
            value_input = adsk.core.ValueInput.createByReal(value)
            existing = design.userParameters.itemByName(name)
            if existing:
                existing.expression = raw_value
                if notes:
                    existing.comment = notes
            else:
                design.userParameters.add(name, value_input, units if units != "unitless" else "", notes)
            count += 1
    return count


def _import_stl(stl_path: str, design: adsk.fusion.Design) -> None:
    options = APP.importManager.createSTLImportOptions(stl_path)
    APP.importManager.importToTarget(options, design.rootComponent)


class CommandCreatedHandler(adsk.core.CommandCreatedEventHandler):
    def __init__(self):
        super().__init__()

    def notify(self, args):
        try:
            command = args.command
            execute_handler = CommandExecuteHandler()
            command.execute.add(execute_handler)
            _handlers.append(execute_handler)
        except Exception:
            UI.messageBox("KeyBumperSync command setup failed:\n" + traceback.format_exc())


class CommandExecuteHandler(adsk.core.CommandEventHandler):
    def __init__(self):
        super().__init__()

    def notify(self, args):
        try:
            design = adsk.fusion.Design.cast(APP.activeProduct)
            if not design:
                UI.messageBox("Abra um documento de Design no Fusion 360 antes de executar o add-in.")
                return
            stl_path = _choose_file("Select generated bumper STL", "STL files (*.stl)")
            if not stl_path:
                return
            _import_stl(stl_path, design)
            csv_path = _choose_file("Select measured-parameters CSV (optional)", "CSV files (*.csv)")
            loaded = 0
            if csv_path:
                loaded = _load_parameters(csv_path, design)
            UI.messageBox(f"KeyBumperSync completed. STL imported; {loaded} parameter rows loaded.")
        except Exception:
            UI.messageBox("KeyBumperSync failed:\n" + traceback.format_exc())


def run(context):
    try:
        command_definitions = UI.commandDefinitions
        command_definition = command_definitions.itemById(COMMAND_ID)
        if not command_definition:
            command_definition = command_definitions.addButtonDefinition(
                COMMAND_ID, COMMAND_NAME, COMMAND_DESCRIPTION, ""
            )
        created_handler = CommandCreatedHandler()
        command_definition.commandCreated.add(created_handler)
        _handlers.append(created_handler)

        workspace = UI.workspaces.itemById(WORKSPACE_ID)
        panel = workspace.toolbarPanels.itemById(PANEL_ID) if workspace else None
        if panel and not panel.controls.itemById(COMMAND_ID):
            panel.controls.addCommand(command_definition)
        UI.messageBox("KeyBumperSync carregado. Use o botão na aba Solid/Create para importar STL.")
    except Exception:
        UI.messageBox("KeyBumperSync startup failed:\n" + traceback.format_exc())


def stop(context):
    try:
        workspace = UI.workspaces.itemById(WORKSPACE_ID)
        panel = workspace.toolbarPanels.itemById(PANEL_ID) if workspace else None
        control = panel.controls.itemById(COMMAND_ID) if panel else None
        if control:
            control.deleteMe()
        command_definition = UI.commandDefinitions.itemById(COMMAND_ID)
        if command_definition:
            command_definition.deleteMe()
    except Exception:
        UI.messageBox("KeyBumperSync stop failed:\n" + traceback.format_exc())
