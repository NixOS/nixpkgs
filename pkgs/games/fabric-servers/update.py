#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p 'python3.withPackages (p: [p.requests])'

from pathlib import Path
from typing import *
import requests
import hashlib
import base64
import json

URL = "https://meta.fabricmc.net"

HEADERS = {
    "User-Agent": "nixpkgs/update.py",
    "Accept": "application/json"
}

def b64e(x) -> str:
    return base64.b64encode(x).decode("ascii")

def get(url: str, /, headers={}, **kwargs) -> Any:
    r = requests.get(url, headers=HEADERS | headers, **kwargs)
    r.raise_for_status()
    return r.json()

def hashurl(url: str, /, headers={}, **kwargs) -> str:
    STREAM_BLOCK_SIZE = 4096

    r = requests.get(url, stream=True, headers=HEADERS | headers, **kwargs)
    r.raise_for_status()

    hash = hashlib.sha256()
    for x in r.iter_content(STREAM_BLOCK_SIZE):
        hash.update(x)

    digest = hash.digest()

    return f"sha256-{b64e(digest)}"

def generate() -> List[Dict]:
    gameVersions = get(f"{URL}/v2/versions/game")
    gameVersions = filter(lambda x: x["stable"], gameVersions)
    gameVersions = map(lambda x: x["version"], gameVersions)

    loaderVersions = get(f"{URL}/v2/versions/loader")
    loaderVersions = filter(lambda x: x["stable"], loaderVersions)
    loaderVersions = map(lambda x: x["version"], loaderVersions)

    # Always use the latest loader.
    loaderVersion = next(loaderVersions)

    installerVersions = get(f"{URL}/v2/versions/installer")
    installerVersions = filter(lambda x: x["stable"], installerVersions)
    installerVersions = map(lambda x: x["version"], installerVersions)

    # Always use the latest installer.
    installerVersion = next(installerVersions)

    def version(gameVersion) -> Dict:
        print(gameVersion)
        url = f"{URL}/v2/versions/loader/{gameVersion}/{loaderVersion}/{installerVersion}/server/jar"

        return {
            "version": gameVersion,
            "url": url,
            "hash": hashurl(url)
        }

    versions = map(version, gameVersions)
    return list(versions)

if __name__ == "__main__":
    with open(Path(__file__).parent / "versions.json", "w") as f:
        json.dump(generate(), f, indent=2)
        f.write("\n")
