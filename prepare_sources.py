#!/usr/bin/env python3
import json
import subprocess
import os
import re
from pathlib import Path

def main(output):
    root = Path(os.getcwd())
    if not (root/"maintainers/maintainer-list.nix").exists():
        raise Exception("Must be run in the root of nixpkgs")
    proc = subprocess.run([
        "git", "config", "-f", root/".gitmodules", "--get-regexp", "submodule..*.url"
    ], stdout=subprocess.PIPE, check=True)
    # TODO this doesn't work if the name contains spaces
    config_re = re.compile('submodule.(.*).url (.*)')
    urls = {}
    for config in proc.stdout.split(b'\n'):
        if len(config) == 0:
            continue
        path, url = re.match(config_re, config.decode()).groups()
        urls[path] = url
    proc = subprocess.run(["git", "submodule", "status"], stdout=subprocess.PIPE, check=True)
    status_re = re.compile('([ \-+U])([0-9a-f]*) ([^ ]*)')
    result = {}
    for status in proc.stdout.split(b'\n'):
        if len(status) == 0:
            continue
        stat, hash, path = re.match(status_re, status.decode()).groups()
        initialized = stat != "-"
        result[path] = {
            "initialized": initialized,
            "hash": hash,
            "url": urls[path],
            "path": str(root/path),
        }
    json.dump(result, output)

if __name__ == "__main__":
    import sys
    main(sys.stdout)
