"""
auto_rebuild_vitis.py
Automates Vitis 2025.2 platform update & app rebuild.
Usage: python auto_rebuild_vitis.py
"""

import sys
import os

# Must set PYTHONPATH before importing vitis
vitis_path = "D:/Tetro/Tools/Vivado/2025.2/Vitis"
sys.path = [
    vitis_path + "/cli",
    vitis_path + "/cli/python-packages/win64",
    vitis_path + "/cli/python-packages/site-packages",
    vitis_path + "/cli/proto",
    vitis_path + "/scripts/python_pkg",
] + sys.path

import vitis

# Get the workspace root (current directory)
workspace_root = os.getcwd().replace("\\", "/")
print(f"Workspace root: {workspace_root}")

client = vitis.create_client()
client.set_workspace(path=workspace_root)

# Step 1: Update platform hardware (XSA)
print("=== Step 1/3: Updating platform hardware (XSA) ===")
platform = client.get_component(name="platform")
status = platform.update_hw(hw_design = workspace_root + "/Test_Top.xsa")
print(f"  update_hw status: {status}")

# Step 2: Rebuild platform
print("=== Step 2/3: Rebuilding platform ===")
status = platform.build()
print(f"  platform build status: {status}")

# Step 3: Rebuild hello_world application
print("=== Step 3/3: Rebuilding hello_world ===")
comp = client.get_component(name="hello_world")
status = comp.build()
print(f"  hello_world build status: {status}")

print("=== All done! ===")

vitis.dispose()
sys.exit(0)
