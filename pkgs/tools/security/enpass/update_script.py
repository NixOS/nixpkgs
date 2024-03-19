#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.requests
import gzip
import json
import logging
import pathlib
import re
import subprocess
import sys

from packaging import version
import requests

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

current_path = pathlib.Path(__file__).parent
DATA_JSON = current_path.joinpath("data.json").resolve()
logging.debug(f"Path to version file: {DATA_JSON}")
last_new_version = None

with open(DATA_JSON, "r") as versions_file:
    versions = json.load(versions_file)

def find_latest_version(arch):
    CHECK_URL = f'https://apt.enpass.io/dists/stable/main/binary-{arch}/Packages.gz'
    packages = gzip.decompress(requests.get(CHECK_URL).content).decode()

    # Loop every package to find the newest one!
    version_selector = re.compile("Version: (?P<version>.+)")
    path_selector = re.compile("Filename: (?P<path>.+)")
    hash_selector = re.compile("SHA256: (?P<sha256>.+)")
    last_version = version.parse("0")
    for package in packages.split("\n\n"):
        matches = version_selector.search(package)
        matched_version = matches.group('version') if matches and matches.group('version') else "0"
        parsed_version = version.parse(matched_version)
        if parsed_version > last_version:
            path = path_selector.search(package).group('path')
            sha256 = hash_selector.search(package).group('sha256')
            last_version = parsed_version
            return {"path": path, "sha256": sha256, "version": matched_version}

for arch in versions.keys():
    current_version = versions[arch]['version']
    logging.info(f"Current Version for {arch} is {current_version}")
    new_version = find_latest_version(arch)

    if not new_version or new_version['version'] == current_version:
        continue

    last_current_version = current_version
    last_new_version = new_version
    logging.info(f"Update found ({arch}): enpass: {current_version} -> {new_version['version']}")
    versions[arch]['path'] = new_version['path']
    versions[arch]['sha256'] = new_version['sha256']
    versions[arch]['version'] = new_version['version']


if not last_new_version:
    logging.info('#### No update found ####')
    sys.exit(0)

# write new versions back
with open(DATA_JSON, "w") as versions_file:
    json.dump(versions, versions_file, indent=2)
    versions_file.write("\n")

# Commit the result:
logging.info("Committing changes...")
commit_message = f"enpass: {last_current_version} -> {last_new_version['version']}"
subprocess.run(['git', 'add', DATA_JSON], check=True)
subprocess.run(['git', 'commit', '--file=-'], input=commit_message.encode(), check=True)

logging.info("Done.")
