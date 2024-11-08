#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.semver nix-prefetch-github
from urllib.request import Request, urlopen
import dataclasses
import subprocess
import os.path
import semver
from typing import (
    Optional,
    Dict,
    List,
)
import json
import os


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
NIXPKGS = os.path.abspath(os.path.join(SCRIPT_DIR, "../../../../"))


OWNER = "LemmyNet"
UI_REPO = "lemmy-ui"
SERVER_REPO = "lemmy"


@dataclasses.dataclass
class Pin:
    serverVersion: str
    uiVersion: str
    serverHash: str = ""
    serverCargoHash: str = ""
    uiHash: str = ""
    uiPNPMDepsHash: str = ""

    filename: Optional[str] = None

    def write(self) -> None:
        if not self.filename:
            raise ValueError("No filename set")

        with open(self.filename, "w") as fd:
            pin = dataclasses.asdict(self)
            del pin["filename"]
            json.dump(pin, fd, indent=2)
            fd.write("\n")


def github_get(path: str) -> Dict:
    """Send a GET request to GitHub, optionally adding GITHUB_TOKEN auth header"""
    url = f"https://api.github.com/{path.lstrip('/')}"
    print(f"Retrieving {url}")

    req = Request(url)

    if "GITHUB_TOKEN" in os.environ:
        req.add_header("authorization", f"Bearer {os.environ['GITHUB_TOKEN']}")

    with urlopen(req) as resp:
        return json.loads(resp.read())


def get_latest_release(owner: str, repo: str) -> str:
    return github_get(f"/repos/{owner}/{repo}/releases/latest")["tag_name"]


def prefetch_github(owner: str, repo: str, rev: str) -> str:
    """Prefetch GitHub rev and return SRI hash"""
    print(f"Prefetching {owner}/{repo}({rev})")

    proc = subprocess.run(
        ["nix-prefetch-github", owner, repo, "--rev", rev, "--fetch-submodules"],
        check=True,
        stdout=subprocess.PIPE,
    )

    return json.loads(proc.stdout)["hash"]


def get_latest_tag(owner: str, repo: str, prerelease: bool = False) -> str:
    """Get the latest tag from a GitHub Repo"""
    tags: List[str] = []

    # As the GitHub API doesn't have any notion of "latest" for tags we need to
    # collect all of them and sort so we can figure out the latest one.
    i = 0
    while i <= 100:  # Prevent infinite looping
        i += 1
        resp = github_get(f"/repos/{owner}/{repo}/tags?page={i}")
        if not resp:
            break

        # Filter out unparseable tags
        for tag in resp:
            try:
                parsed = semver.Version.parse(tag["name"])
                if (
                    semver.Version.parse(tag["name"])
                    and not prerelease
                    and parsed.prerelease
                ):  # Filter out release candidates
                    continue
            except ValueError:
                continue
            else:
                tags.append(tag["name"])

    # Sort and return latest
    return sorted(tags, key=lambda name: semver.Version.parse(name))[-1]


def get_fod_hash(attr: str) -> str:
    """
    Get fixed output hash for attribute.
    This depends on a fixed output derivation with an empty hash.
    """

    print(f"Getting fixed output hash for {attr}")

    proc = subprocess.run(["nix-build", NIXPKGS, "-A", attr], stderr=subprocess.PIPE)
    if proc.returncode != 1:
        raise ValueError("Expected nix-build to fail")

    # Iterate list in reverse order so we get the "got:" line early
    for line in proc.stderr.decode().split("\n")[::-1]:
        cols = line.split()
        if cols and cols[0] == "got:":
            return cols[1]

    raise ValueError("No fixed output hash found")


def make_server_pin(pin: Pin, attr: str) -> None:
    pin.serverHash = prefetch_github(OWNER, SERVER_REPO, pin.serverVersion)
    pin.write()
    pin.serverCargoHash = get_fod_hash(attr)
    pin.write()


def make_ui_pin(pin: Pin, attr: str) -> None:
    pin.uiHash = prefetch_github(OWNER, UI_REPO, pin.uiVersion)
    pin.write()
    pin.uiPNPMDepsHash = get_fod_hash(attr)
    pin.write()


if __name__ == "__main__":
    # Get server version
    server_version = get_latest_tag(OWNER, SERVER_REPO)

    # Get UI version (not always the same as lemmy-server)
    ui_version = get_latest_tag(OWNER, UI_REPO)

    pin = Pin(server_version, ui_version, filename=os.path.join(SCRIPT_DIR, "pin.json"))
    make_server_pin(pin, "lemmy-server")
    make_ui_pin(pin, "lemmy-ui")
