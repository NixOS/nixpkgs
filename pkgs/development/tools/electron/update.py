#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3.pkgs.joblib python3.pkgs.click python3.pkgs.click-log nix nurl prefetch-yarn-deps prefetch-npm-deps gclient2nix
"""
electron updater

A script for updating electron source hashes.

It supports the following modes:

| Mode         | Description                                     |
|------------- | ----------------------------------------------- |
| `update`     | for updating a specific Electron release        |
| `update-all` | for updating all electron releases at once      |

The `update` commands requires a `--version` flag
to specify the major release to be updated.
The `update-all command updates all non-eol major releases.

The `update` and `update-all` commands accept an optional `--commit`
flag to automatically commit the changes for you.
"""
import base64
import json
import logging
import os
import random
import re
import subprocess
import sys
import tempfile
import urllib.request
import click
import click_log

from datetime import datetime, UTC
from typing import Iterable, Tuple
from urllib.request import urlopen
from joblib import Parallel, delayed, Memory
from update_util import *


# Relative path to the electron-source info.json
SOURCE_INFO_JSON = "info.json"

os.chdir(os.path.dirname(__file__))

# Absolute path of nixpkgs top-level directory
NIXPKGS_PATH = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()

memory: Memory = Memory("cache", verbose=0)

logger = logging.getLogger(__name__)
click_log.basic_config(logger)


def get_gclient_data(rev: str) -> any:
    output = subprocess.check_output(
        ["gclient2nix", "generate",
         f"https://github.com/electron/electron@{rev}",
         "--root", "src/electron"]
    )

    return json.loads(output)


def get_chromium_file(chromium_tag: str, filepath: str) -> str:
    return base64.b64decode(
        urlopen(
            f"https://chromium.googlesource.com/chromium/src.git/+/{chromium_tag}/{filepath}?format=TEXT"
        ).read()
        ).decode("utf-8")


def get_electron_file(electron_tag: str, filepath: str) -> str:
    return (
        urlopen(
            f"https://raw.githubusercontent.com/electron/electron/{electron_tag}/{filepath}"
        )
        .read()
        .decode("utf-8")
    )


@memory.cache
def get_gn_hash(gn_version, gn_commit):
    print("gn.override", file=sys.stderr)
    expr = f'(import {NIXPKGS_PATH} {{}}).gn.override {{ version = "{gn_version}"; rev = "{gn_commit}"; hash = ""; }}'
    out = subprocess.check_output(["nurl", "--hash", "--expr", expr])
    return out.decode("utf-8").strip()

@memory.cache
def get_chromium_gn_source(chromium_tag: str) -> dict:
    gn_pattern = r"'gn_version': 'git_revision:([0-9a-f]{40})'"
    gn_commit = re.search(gn_pattern, get_chromium_file(chromium_tag, "DEPS")).group(1)

    gn_commit_info = json.loads(
        urlopen(f"https://gn.googlesource.com/gn/+/{gn_commit}?format=json")
        .read()
        .decode("utf-8")
        .split(")]}'\n")[1]
    )

    gn_commit_date = datetime.strptime(gn_commit_info["committer"]["time"], "%a %b %d %H:%M:%S %Y %z")
    gn_date = gn_commit_date.astimezone(UTC).date().isoformat()
    gn_version = f"0-unstable-{gn_date}"

    return {
        "gn": {
            "version": gn_version,
            "rev": gn_commit,
            "hash": get_gn_hash(gn_version, gn_commit),
        }
    }

@memory.cache
def get_electron_yarn_hash(electron_tag: str) -> str:
    print(f"prefetch-yarn-deps", file=sys.stderr)
    with tempfile.TemporaryDirectory() as tmp_dir:
        with open(tmp_dir + "/yarn.lock", "w") as f:
            f.write(get_electron_file(electron_tag, "yarn.lock"))
        return (
            subprocess.check_output(["prefetch-yarn-deps", tmp_dir + "/yarn.lock"])
            .decode("utf-8")
            .strip()
        )

@memory.cache
def get_chromium_npm_hash(chromium_tag: str) -> str:
    print(f"prefetch-npm-deps", file=sys.stderr)
    with tempfile.TemporaryDirectory() as tmp_dir:
        with open(tmp_dir + "/package-lock.json", "w") as f:
            f.write(get_chromium_file(chromium_tag, "third_party/node/package-lock.json"))
        return (
            subprocess.check_output(
                ["prefetch-npm-deps", tmp_dir + "/package-lock.json"]
            )
            .decode("utf-8")
            .strip()
        )


def get_update(major_version: str, m: str, gclient_data: any) -> Tuple[str, dict]:

    tasks = []
    a = lambda: (("electron_yarn_hash", get_electron_yarn_hash(gclient_data["src/electron"]["args"]["tag"])))
    tasks.append(delayed(a)())
    a = lambda: (
        (
            "chromium_npm_hash",
            get_chromium_npm_hash(gclient_data["src"]["args"]["tag"]),
        )
    )
    tasks.append(delayed(a)())
    random.shuffle(tasks)

    task_results = {
        n[0]: n[1]
        for n in Parallel(n_jobs=3, require="sharedmem", return_as="generator")(tasks)
        if n != None
    }

    return (
        f"{major_version}",
        {
            "deps": gclient_data,
            **{key: m[key] for key in ["version", "modules", "chrome", "node"]},
            "chromium": {
                "version": m["chrome"],
                "deps": get_chromium_gn_source(gclient_data["src"]["args"]["tag"]),
            },
            **task_results,
        },
    )


def non_eol_releases(releases: Iterable[int]) -> Iterable[int]:
    """Returns a list of releases that have not reached end-of-life yet."""
    return tuple(filter(lambda x: x in supported_version_range(), releases))


def update_source(version: str, commit: bool) -> None:
    """Update a given electron-source release

    Args:
        version: The major version number, e.g. '27'
        commit: Whether the updater should commit the result
    """
    major_version = version

    package_name = f"electron-source.electron_{major_version}"
    print(f"Updating electron-source.electron_{major_version}")

    old_info = load_info_json(SOURCE_INFO_JSON)
    old_version = (
        old_info[major_version]["version"]
        if major_version in old_info
        else None
    )

    m, rev = get_latest_version(major_version)
    if old_version == m["version"]:
        print(f"{package_name} is up-to-date")
        return

    gclient_data = get_gclient_data(rev)
    new_info = get_update(major_version, m, gclient_data)
    out = old_info | {new_info[0]: new_info[1]}

    save_info_json(SOURCE_INFO_JSON, out)

    new_version = new_info[1]["version"]
    if commit:
        commit_result(package_name, old_version, new_version, SOURCE_INFO_JSON)


@click.group()
def cli() -> None:
    """A script for updating electron-source hashes"""
    pass


@cli.command("update", help="Update a single major release")
@click.option("-v", "--version", required=True, type=str, help="The major version, e.g. '23'")
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update(version: str, commit: bool) -> None:
    update_source(version, commit)


@cli.command("update-all", help="Update all releases at once")
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update_all(commit: bool) -> None:
    """Update all eletron-source releases at once

    Args:
        commit: Whether to commit the result
    """
    old_info = load_info_json(SOURCE_INFO_JSON)

    filtered_releases = non_eol_releases(tuple(map(lambda x: int(x), old_info.keys())))

    for major_version in filtered_releases:
        update_source(str(major_version), commit)


if __name__ == "__main__":
    cli()
