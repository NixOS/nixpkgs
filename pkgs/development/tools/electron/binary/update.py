#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3.pkgs.click python3.pkgs.click-log nix
"""
electron updater

A script for updating binary hashes.

It supports the following modes:

| Mode         | Description                                     |
|------------- | ----------------------------------------------- |
| `update`     | for updating a specific Electron release        |
| `update-all` | for updating all electron releases at once      |

The `update` command requires a `--version` flag
to specify the major release to be update.
The `update-all` command updates all non-eol major releases.

The `update` and `update-all` commands accept an optional `--commit`
flag to automatically commit the changes for you.
"""
import logging
import os
import subprocess
import sys
import click
import click_log

from typing import Tuple
os.chdir(os.path.dirname(__file__))
sys.path.append("..")
from update_util import *


# Relatice path to the electron-bin info.json
BINARY_INFO_JSON = "info.json"

# Relative path the the electron-chromedriver info.json
CHROMEDRIVER_INFO_JSON = "../chromedriver/info.json"

logger = logging.getLogger(__name__)
click_log.basic_config(logger)


systems = {
    "i686-linux": "linux-ia32",
    "x86_64-linux": "linux-x64",
    "armv7l-linux": "linux-armv7l",
    "aarch64-linux": "linux-arm64",
    "x86_64-darwin": "darwin-x64",
    "aarch64-darwin": "darwin-arm64",
}

def get_shasums256(version: str) -> list:
    """Returns the contents of SHASUMS256.txt"""
    try:
        called_process: subprocess.CompletedProcess = subprocess.run(
            [
                "nix-prefetch-url",
                "--print-path",
                f"https://github.com/electron/electron/releases/download/v{version}/SHASUMS256.txt",
            ],
            capture_output=True,
            check=True,
            text=True,
        )

        hash_file_path = called_process.stdout.split("\n")[1]

        with open(hash_file_path, "r") as f:
            return f.read().split("\n")

    except subprocess.CalledProcessError as err:
        print(err.stderr)
        sys.exit(1)


def get_headers(version: str) -> str:
    """Returns the hash of the release headers tarball"""
    try:
        called_process: subprocess.CompletedProcess = subprocess.run(
            [
                "nix-prefetch-url",
                "--unpack",
                f"https://artifacts.electronjs.org/headers/dist/v{version}/node-v{version}-headers.tar.gz",
            ],
            capture_output=True,
            check=True,
            text=True,
        )
        return called_process.stdout.split("\n")[0]
    except subprocess.CalledProcessError as err:
        print(err.stderr)
        sys.exit(1)


def get_electron_hashes(major_version: str) -> dict:
    """Returns a dictionary of hashes for a given major version"""
    m, _ = get_latest_version(major_version)
    version: str = m["version"]

    out = {}
    out[major_version] = {
        "hashes": {},
        "version": version,
    }

    hashes: list = get_shasums256(version)

    for nix_system, electron_system in systems.items():
        filename = f"*electron-v{version}-{electron_system}.zip"
        if any([x.endswith(filename) for x in hashes]):
            out[major_version]["hashes"][nix_system] = [
                x.split(" ")[0] for x in hashes if x.endswith(filename)
            ][0]
            out[major_version]["hashes"]["headers"] = get_headers(version)

    return out


def get_chromedriver_hashes(major_version: str) -> dict:
    """Returns a dictionary of hashes for a given major version"""
    m, _ = get_latest_version(major_version)
    version: str = m["version"]

    out = {}
    out[major_version] = {
        "hashes": {},
        "version": version,
    }

    hashes: list = get_shasums256(version)

    for nix_system, electron_system in systems.items():
        filename = f"*chromedriver-v{version}-{electron_system}.zip"
        if any([x.endswith(filename) for x in hashes]):
            out[major_version]["hashes"][nix_system] = [
                x.split(" ")[0] for x in hashes if x.endswith(filename)
            ][0]
            out[major_version]["hashes"]["headers"] = get_headers(version)

    return out


def update_binary(major_version: str, commit: bool, chromedriver: bool) -> None:
    """Update a given electron-bin or chromedriver release

    Args:
        major_version: The major version number, e.g. '27'
        commit: Whether the updater should commit the result
    """
    if chromedriver:
        json_path=CHROMEDRIVER_INFO_JSON
        package_name = f"electron-chromedriver_{major_version}"
        update_fn=get_chromedriver_hashes
    else:
        json_path=BINARY_INFO_JSON
        package_name = f"electron_{major_version}-bin"
        update_fn = get_electron_hashes
    print(f"Updating {package_name}")

    old_info = load_info_json(json_path)
    new_info = update_fn(major_version)

    out = old_info | new_info

    save_info_json(json_path, out)

    old_version = (
        old_info[major_version]["version"] if major_version in old_info else None
    )
    new_version = new_info[major_version]["version"]
    if old_version == new_version:
        print(f"{package_name} is up-to-date")
    elif commit:
        commit_result(package_name, old_version, new_version, json_path)


@click.group()
def cli() -> None:
    """A script for updating electron-bin and chromedriver hashes"""
    pass


@cli.command("update-chromedriver", help="Update a single major release")
@click.option("-v", "--version", help="The major version, e.g. '23'")
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update_chromedriver(version: str, commit: bool) -> None:
    update_binary(version, commit, True)


@cli.command("update", help="Update a single major release")
@click.option("-v", "--version", required=True, type=str, help="The major version, e.g. '23'")
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update(version: str, commit: bool) -> None:
    update_binary(version, commit, False)
    update_binary(version, commit, True)


@cli.command("update-all", help="Update all releases at once")
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update_all(commit: bool) -> None:
    # Filter out releases that have reached end-of-life
    filtered_bin_info = dict(
        filter(
            lambda entry: int(entry[0]) in supported_version_range(),
            load_info_json(BINARY_INFO_JSON).items(),
        )
    )

    for major_version, _ in filtered_bin_info.items():
        update_binary(str(major_version), commit, False)
        update_binary(str(major_version), commit, True)


if __name__ == "__main__":
    cli()
