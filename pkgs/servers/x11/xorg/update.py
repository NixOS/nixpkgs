#!/usr/bin/env nix-shell
#!nix-shell --pure --keep NIX_PATH -i python3 -p nix git nixfmt "python3.withPackages (ps: [ ps. packaging ps.beautifulsoup4 ps.requests ])"

# Usage: Run ./update.py from the directory containing tarballs.list. The script checks for the
# latest versions of all packages, updates the expressions if any update is found, and commits
# any changes.

import subprocess

import requests
from bs4 import BeautifulSoup
from packaging import version

mirror = "mirror://xorg/"
allversions = {}

print("Downloading latest version info...")

# xorg packages
for component in [
    "individual/app",
    "individual/data",
    "individual/data/xkeyboard-config",
    "individual/doc",
    "individual/driver",
    "individual/font",
    "individual/lib",
    "individual/proto",
    "individual/util",
    "individual/xcb",
    "individual/xserver",
]:
    url = "https://xorg.freedesktop.org/releases/{}/".format(component)
    r = requests.get(url)
    soup = BeautifulSoup(r.text, "html.parser")
    for a in soup.table.find_all("a"):
        href = a["href"]
        if not href.endswith((".tar.bz2", ".tar.gz", ".tar.xz")):
            continue

        pname, rem = href.rsplit("-", 1)
        ver, _, ext = rem.rsplit(".", 2)

        if "rc" in ver:
            continue

        entry = allversions.setdefault(f"{mirror}{component}/{pname}", ([], {}))
        entry[0].append(version.parse(ver))
        entry[1][ver] = f"{mirror}{component}/{href}"

print("Finding updated versions...")

with open("./tarballs.list") as f:
    lines_tarballs = f.readlines()

updated_tarballs = []
changes = {}
changes_text = []
for line in lines_tarballs:
    line = line.rstrip("\n")

    if line.startswith(mirror):
        pname, rem = line.rsplit("-", 1)
        if line.startswith(mirror):
            ver, _, _ = rem.rsplit(".", 2)
        else:
            ver, _ = rem.rsplit(".", 1)

        if pname not in allversions:
            print("# WARNING: no version found for {}".format(pname))
            continue

        highest = max(allversions[pname][0])
        if highest > version.parse(ver):
            line = allversions[pname][1][str(highest)]
            text = f"{pname.split('/')[-1]}: {ver} -> {str(highest)}"
            print(f"    Updating {text}")
            changes[pname] = line
            changes_text.append(text)

    updated_tarballs.append(line)

if len(changes) == 0:
    print("No updates found")
    exit()

print("Updating tarballs.list...")

with open("./tarballs.list", "w") as f:
    f.writelines(f'{tarball}\n' for tarball in updated_tarballs)

print("Generating updated expr (slow)...")

subprocess.run(["./generate-expr-from-tarballs.pl", "tarballs.list"], check=True)

print("Formatting generated expr...")

subprocess.run(["nixfmt", "default.nix"], check=True)

print("Committing...")

subprocess.run(["git", "add", "default.nix", "tarballs.list"], check=True)
subprocess.run(["git", "commit", "-mxorg.*: update\n\n%s" % "\n".join(changes_text)], check=True)
