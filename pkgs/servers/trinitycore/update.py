#!/usr/bin/env nix-shell
#!nix-shell -p nix-prefetch-git -p jq -p python3 -i python3
from subprocess import run, PIPE
import fileinput
import json
import re


owner = "vmangos"
repo = "core"

response = run(["nix-prefetch-git", f"git://github.com/{owner}/{repo}.git"], stdout=PIPE)

document = json.loads(response.stdout)

rev = document["rev"]
sha256 = document["sha256"]
datetime = document["date"].split("T")[0]
version = f"unstable-{date}"

with fileinput.FileInput("default.nix", inplace=True) as file:
    for line in file:
        line = re.sub("

