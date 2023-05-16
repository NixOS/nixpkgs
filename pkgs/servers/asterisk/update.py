#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.beautifulsoup4 python3.pkgs.requests
=======
#!nix-shell -i python3 -p python39 python39.pkgs.packaging python39.pkgs.beautifulsoup4 python39.pkgs.requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# mirrored in ./default.nix
from packaging import version
from bs4 import BeautifulSoup
import re, requests, json
import os, sys
from pathlib import Path

<<<<<<< HEAD
URL = "https://downloads.asterisk.org/pub/telephony/asterisk/"

page = requests.get(URL)
changelog = re.compile("^ChangeLog-\d+\.\d+\.\d+\.md$")
changelogs = [a.get_text() for a in BeautifulSoup(page.text, 'html.parser').find_all('a') if changelog.match(a.get_text())]
major_versions = {}
for changelog in changelogs:
    v = version.parse(changelog.removeprefix("ChangeLog-").removesuffix(".md"))
=======
URL = "https://downloads.asterisk.org/pub/telephony/asterisk"

page = requests.get(URL)
changelog = re.compile("^ChangeLog-\d+\.\d+\.\d+$")
changelogs = [a.get_text() for a in BeautifulSoup(page.text, 'html.parser').find_all('a') if changelog.match(a.get_text())]
major_versions = {}
for changelog in changelogs:
    v = version.parse(changelog.removeprefix("ChangeLog-"))
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    major_versions.setdefault(v.major, []).append(v)

out = {}
for mv in major_versions.keys():
    v = max(major_versions[mv])
    sha = requests.get(f"{URL}/asterisk-{v}.sha256").text.split()[0]
    out["asterisk_" + str(mv)] = {
        "version": str(v),
        "sha256": sha
    }

versions_path = Path(sys.argv[0]).parent / "versions.json"

try:
    with open(versions_path, "r") as in_file:
        in_data = json.loads(in_file.read())
        for v in in_data.keys():
            print(v + ":", in_data[v]["version"], "->", out[v]["version"])
except:
    # nice to have for the PR, not a requirement
    pass

with open(versions_path, "w") as out_file:
    out_file.write(json.dumps(out, sort_keys=True, indent=2) + "\n")
