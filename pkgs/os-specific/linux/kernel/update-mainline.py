#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: [ ps.beautifulsoup4 ps.lxml ])"
import json
import os
import pathlib
import subprocess
import sys
import urllib.request
from dataclasses import dataclass
from enum import Enum

from bs4 import BeautifulSoup, NavigableString, Tag

HERE = pathlib.Path(__file__).parent
ROOT = HERE.parent.parent.parent.parent
VERSIONS_FILE = HERE / "kernels-org.json"


class KernelNature(Enum):
    MAINLINE = 1
    STABLE = 2
    LONGTERM = 3


@dataclass
class KernelRelease:
    nature: KernelNature
    version: str
    branch: str
    date: str
    link: str
    eol: bool = False


def parse_release(release: Tag) -> KernelRelease | None:
    columns: list[Tag] = list(release.find_all("td"))
    try:
        nature = KernelNature[columns[0].get_text().rstrip(":").upper()]
    except KeyError:
        return None

    version = columns[1].get_text().rstrip(" [EOL]")
    date = columns[2].get_text()
    link = columns[3].find("a")
    if link is not None and isinstance(link, Tag):
        link = link.attrs.get("href")
    assert link is not None, f"link for kernel {version} is non-existent"
    eol = bool(release.find(class_="eolkernel"))

    return KernelRelease(
        nature=nature,
        branch=get_branch(version),
        version=version,
        date=date,
        link=link,
        eol=eol,
    )


def get_branch(version: str):
    # This is a testing kernel.
    if "rc" in version:
        return "testing"
    else:
        major, minor, *_ = version.split(".")
        return f"{major}.{minor}"


def get_hash(kernel: KernelRelease):
    if kernel.branch == "testing":
        args = ["--unpack"]
    else:
        args = []

    hash = (
        subprocess.check_output(["nix-prefetch-url", kernel.link] + args)
        .decode()
        .strip()
    )
    return f"sha256:{hash}"


def commit(message):
    return subprocess.check_call(["git", "commit", "-m", message, VERSIONS_FILE])


def main():
    kernel_org = urllib.request.urlopen("https://kernel.org/")
    soup = BeautifulSoup(kernel_org.read().decode(), "lxml")
    release_table = soup.find(id="releases")
    if not release_table or isinstance(release_table, NavigableString):
        print(release_table, file=sys.stderr)
        print("Failed to find the release table on https://kernel.org", file=sys.stderr)
        sys.exit(1)

    releases = release_table.find_all("tr")
    parsed_releases = filter(None, [parse_release(release) for release in releases])
    all_kernels = json.load(VERSIONS_FILE.open())

    for kernel in parsed_releases:
        branch = get_branch(kernel.version)
        nixpkgs_branch = branch.replace(".", "_")

        old_version = all_kernels.get(branch, {}).get("version")
        if old_version == kernel.version:
            print(f"linux_{nixpkgs_branch}: {kernel.version} is latest, skipping...")
            continue

        if old_version is None:
            message = f"linux_{nixpkgs_branch}: init at {kernel.version}"
        else:
            message = f"linux_{nixpkgs_branch}: {old_version} -> {kernel.version}"

        print(message, file=sys.stderr)

        all_kernels[branch] = {
            "version": kernel.version,
            "hash": get_hash(kernel),
        }

        with VERSIONS_FILE.open("w") as fd:
            json.dump(all_kernels, fd, indent=4)
            fd.write("\n")  # makes editorconfig happy

        if os.environ.get("COMMIT") == "1":
            commit(message)


if __name__ == "__main__":
    main()
