#!/usr/bin/env nix-shell
#!nix-shell -i python -p python3 nix-prefetch-github git

import subprocess
import json
import os.path

BRANCHES = ["5.10-lts", "5.15-lts", "6.1-lts"]
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

versions = dict()

for branch in BRANCHES:
    text = subprocess.check_output(
        ["nix-prefetch-github", "freebsd", "drm-kmod", "--rev", branch, "--json"]
    ).decode("utf-8")
    versions[branch] = json.loads(text)

with open(os.path.join(BASE_DIR, "versions.json"), "w") as out:
    json.dump(versions, out, sort_keys=True, indent=2)
    out.write("\n")
