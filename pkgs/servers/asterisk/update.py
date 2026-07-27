#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.beautifulsoup4 python3.pkgs.requests
# mirrored in ./default.nix
import hashlib
import json
import re
import sys
from pathlib import Path

import requests
from bs4 import BeautifulSoup
from packaging import version

URL = "https://downloads.asterisk.org/pub/telephony/asterisk/"
PJPROJECT_API_URL = (
    "https://api.github.com/repos/asterisk/asterisk/contents/third-party/pjproject"
)
PJPROJECT_URL = (
    "https://raw.githubusercontent.com/asterisk/third-party/master/pjproject"
)

page = requests.get(URL)
changelog = re.compile(r"^ChangeLog-\d+\.\d+\.\d+\.md$")
changelogs = [
    a.get_text()
    for a in BeautifulSoup(page.text, "html.parser").find_all("a")
    if changelog.match(a.get_text())
]
major_versions = {}
for changelog in changelogs:
    v = version.parse(changelog.removeprefix("ChangeLog-").removesuffix(".md"))
    major_versions.setdefault(v.major, []).append(v)

out = {}
pjproject_hashes = {}
for mv in major_versions.keys():
    v = max(major_versions[mv])
    sha = requests.get(f"{URL}/asterisk-{v}.sha256").text.split()[0]
    pjproject_files = requests.get(PJPROJECT_API_URL, params={"ref": str(v)})
    pjproject_files.raise_for_status()
    pjproject_archive = next(
        entry["name"]
        for entry in pjproject_files.json()
        if entry["name"].startswith("pjproject-")
        and entry["name"].endswith(".tar.bz2.md5")
    ).removesuffix(".md5")
    pjproject_version = pjproject_archive.removeprefix("pjproject-").removesuffix(
        ".tar.bz2"
    )
    if pjproject_version not in pjproject_hashes:
        pjproject_source = requests.get(
            f"{PJPROJECT_URL}/{pjproject_version}/{pjproject_archive}"
        )
        pjproject_source.raise_for_status()
        pjproject_hashes[pjproject_version] = hashlib.sha256(
            pjproject_source.content
        ).hexdigest()
    out["asterisk_" + str(mv)] = {
        "version": str(v),
        "sha256": sha,
        "pjproject": {
            "version": pjproject_version,
            "sha256": pjproject_hashes[pjproject_version],
        },
    }

versions_path = Path(sys.argv[0]).parent / "versions.json"

try:
    with open(versions_path, "r") as in_file:
        in_data = json.loads(in_file.read())
except (OSError, json.JSONDecodeError):
    # nice to have for the PR, not a requirement
    in_data = {}

for name, release in out.items():
    previous_version = in_data.get(name, {}).get("version", "new")
    print(name + ":", previous_version, "->", release["version"])
for name in in_data.keys() - out.keys():
    print(name + ":", in_data[name]["version"], "-> removed")

with open(versions_path, "w") as out_file:
    out_file.write(json.dumps(out, sort_keys=True, indent=2) + "\n")
