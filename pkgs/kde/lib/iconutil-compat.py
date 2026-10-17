import argparse
import os
import shutil
import sys
from pathlib import Path

# https://manp.gs/mac/1/iconutil
parser = argparse.ArgumentParser(
    description="iconutil compatibility shim"
)
parser.add_argument("-c", "--convert", required=True, choices=["icns"])
parser.add_argument("-o", "--output", type=Path)
parser.add_argument("iconset", type=Path)
args = parser.parse_args()

output = args.output or args.iconset.with_suffix(".icns")
icons = sorted(str(f) for f in args.iconset.glob("icon_*.png"))
if not icons:
    sys.exit(f"no usable icons in {args.iconset}")

icnsutil = shutil.which("icnsutil")
if icnsutil is None:
    sys.exit("icnsutil not found in PATH")

os.execv(icnsutil, [icnsutil, "compose", "--toc", "-f", str(output), *icons])
