#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p common-updater-scripts nix python3

import json
import os
import re
import subprocess
import sys
import urllib.request

GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
if len(sys.argv) != 2:
    raise SystemExit(f"usage: {sys.argv[0]} PACKAGE_NAME")
PACKAGE_NAME = sys.argv[1]
SYSTEMS = [
    ("darwin", "arm64", "aarch64-darwin"),
    ("linux", "arm64", "aarch64-linux"),
    ("linux", "arm", "armv7l-linux"),
    ("linux", "amd64", "x86_64-linux"),
    ("linux", "386", "i686-linux"),
]


def github_request(url):
    request = urllib.request.Request(url)
    request.add_header("Accept", "application/vnd.github+json")
    request.add_header("User-Agent", "nixpkgs-ocis-bin-updater")
    if GITHUB_TOKEN:
        request.add_header("Authorization", f"Bearer {GITHUB_TOKEN}")
    return request


def current_version():
    result = subprocess.run(
        [
            "nix-instantiate",
            "--eval",
            "--raw",
            "-A",
            f"{PACKAGE_NAME}.version",
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def releases():
    result = []
    page = 1
    while True:
        url = (
            "https://api.github.com/repos/owncloud/ocis/releases"
            f"?per_page=100&page={page}"
        )
        with urllib.request.urlopen(github_request(url)) as response:
            batch = json.load(response)
        if not batch:
            return result
        result.extend(batch)
        page += 1


def latest_patch(version):
    major_minor = ".".join(version.split(".")[:2])
    pattern = re.compile(rf"^{re.escape(major_minor)}\.[0-9]+$")
    candidates = []
    for release in releases():
        release_version = release["tag_name"].removeprefix("v")
        if (
            not release["draft"]
            and not release["prerelease"]
            and pattern.fullmatch(release_version)
        ):
            candidates.append(release_version)
    if not candidates:
        raise RuntimeError(f"No stable {major_minor}.x releases found")
    return max(candidates, key=lambda value: tuple(map(int, value.split("."))))


def source_hash(version, os_name, arch):
    filename = f"ocis-{version}-{os_name}-{arch}"
    url = (
        f"https://github.com/owncloud/ocis/releases/download/v{version}/"
        f"{filename}.sha256"
    )
    with urllib.request.urlopen(github_request(url)) as response:
        checksum = response.read().decode().split()[0]
    if not re.fullmatch(r"[0-9a-f]{64}", checksum):
        raise RuntimeError(f"Invalid checksum for {filename}: {checksum}")
    result = subprocess.run(
        [
            "nix",
            "hash",
            "convert",
            "--hash-algo",
            "sha256",
            "--to",
            "sri",
            checksum,
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def update(version, hash_value, system):
    subprocess.run(
        [
            "update-source-version",
            PACKAGE_NAME,
            version,
            hash_value,
            f"--system={system}",
            "--ignore-same-version",
            "--file=pkgs/servers/ocis-bin/default.nix",
        ],
        check=True,
    )


def main():
    old_version = current_version()
    new_version = latest_patch(old_version)
    if new_version == old_version:
        print(f"{PACKAGE_NAME} is already up-to-date at {old_version}")
        return

    print(f"Updating {PACKAGE_NAME} from {old_version} to {new_version}")
    for os_name, arch, system in SYSTEMS:
        update(new_version, source_hash(new_version, os_name, arch), system)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"error: {error}", file=sys.stderr)
        raise
