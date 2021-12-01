#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ requests nix-prefetch-github ])" -p "git"

import json
import sys
from pathlib import Path

from nix_prefetch_github import nix_prefetch_github

SCRIPT_PATH = Path(__file__).absolute().parent
HASHES_PATH = SCRIPT_PATH / "hashes.json"
CORES = {
    "atari800": {"repo": "libretro-atari800"},
    "beetle-gba": {"repo": "beetle-gba-libretro"},
    "beetle-lynx": {"repo": "beetle-lynx-libretro"},
    "beetle-ngp": {"repo": "beetle-ngp-libretro"},
    "beetle-pce-fast": {"repo": "beetle-pce-fast-libretro"},
    "beetle-pcfx": {"repo": "beetle-pcfx-libretro"},
    "beetle-psx": {"repo": "beetle-psx-libretro"},
    "beetle-saturn": {"repo": "beetle-saturn-libretro"},
    "beetle-snes": {"repo": "beetle-bsnes-libretro"},
    "beetle-supergrafx": {"repo": "beetle-supergrafx-libretro"},
    "beetle-vb": {"repo": "beetle-vb-libretro"},
    "beetle-wswan": {"repo": "beetle-wswan-libretro"},
    "blastem": {"repo": "blastem"},
    "bluemsx": {"repo": "bluemsx-libretro"},
    "bsnes": {"repo": "bsnes-libretro"},
    "bsnes-hd": {"repo": "bsnes-hd", "owner": "DerKoun"},
    "bsnes-mercury": {"repo": "bsnes-mercury"},
    "citra": {"repo": "citra", "fetch_submodules": True},
    "desmume": {"repo": "desmume"},
    "desmume2015": {"repo": "desmume2015"},
    "dolphin": {"repo": "dolphin"},
    "dosbox": {"repo": "dosbox-libretro"},
    "eightyone": {"repo": "81-libretro"},
    "fbalpha2012": {"repo": "fbalpha2012"},
    "fbneo": {"repo": "fbneo"},
    "fceumm": {"repo": "libretro-fceumm"},
    "flycast": {"repo": "flycast"},
    "fmsx": {"repo": "fmsx-libretro"},
    "freeintv": {"repo": "freeintv"},
    "gambatte": {"repo": "gambatte-libretro"},
    "genesis-plus-gx": {"repo": "Genesis-Plus-GX"},
    "gpsp": {"repo": "gpsp"},
    "gw": {"repo": "gw-libretro"},
    "handy": {"repo": "libretro-handy"},
    "hatari": {"repo": "hatari"},
    "mame": {"repo": "mame"},
    "mame2000": {"repo": "mame2000-libretro"},
    "mame2003": {"repo": "mame2003-libretro"},
    "mame2003-plus": {"repo": "mame2003-plus-libretro"},
    "mame2010": {"repo": "mame2010-libretro"},
    "mame2015": {"repo": "mame2015-libretro"},
    "mame2016": {"repo": "mame2016-libretro"},
    "melonds": {"repo": "melonds"},
    "mesen": {"repo": "mesen"},
    "mesen-s": {"repo": "mesen-s"},
    "meteor": {"repo": "meteor-libretro"},
    "mgba": {"repo": "mgba"},
    "mupen64plus": {"repo": "mupen64plus-libretro-nx"},
    "neocd": {"repo": "neocd_libretro"},
    "nestopia": {"repo": "nestopia"},
    "np2kai": {"repo": "NP2kai", "owner": "AZO234", "fetch_submodules": True},
    "o2em": {"repo": "libretro-o2em"},
    "opera": {"repo": "opera-libretro"},
    "parallel-n64": {"repo": "parallel-n64"},
    "pcsx2": {"repo": "pcsx2"},
    "pcsx_rearmed": {"repo": "pcsx_rearmed"},
    "picodrive": {"repo": "picodrive", "fetch_submodules": True},
    "play": {"repo": "Play-", "owner": "jpd002", "fetch_submodules": True},
    "ppsspp": {"repo": "ppsspp", "owner": "hrydgard", "fetch_submodules": True},
    "prboom": {"repo": "libretro-prboom"},
    "prosystem": {"repo": "prosystem-libretro"},
    "quicknes": {"repo": "QuickNES_Core"},
    "sameboy": {"repo": "sameboy"},
    "scummvm": {"repo": "scummvm"},
    "smsplus-gx": {"repo": "smsplus-gx"},
    "snes9x": {"repo": "snes9x", "owner": "snes9xgit"},
    "snes9x2002": {"repo": "snes9x2002"},
    "snes9x2005": {"repo": "snes9x2005"},
    "snes9x2010": {"repo": "snes9x2010"},
    "stella": {"repo": "stella", "owner": "stella-emu"},
    "stella2014": {"repo": "stella2014-libretro"},
    "swanstation": {"repo": "swanstation"},
    "tgbdual": {"repo": "tgbdual-libretro"},
    "thepowdertoy": {"repo": "ThePowderToy"},
    "tic80": {"repo": "tic-80", "fetch_submodules": True},
    "vba-m": {"repo": "vbam-libretro"},
    "vba-next": {"repo": "vba-next"},
    "vecx": {"repo": "libretro-vecx"},
    "virtualjaguar": {"repo": "virtualjaguar-libretro"},
    "yabause": {"repo": "yabause"},
}


def info(*msg):
    print(*msg, file=sys.stderr)


def get_repo_hash_fetchFromGitHub(repo, owner="libretro", fetch_submodules=False):
    assert repo is not None, "Parameter 'repo' can't be None."

    repo_hash = nix_prefetch_github(
        owner=owner, repo=repo, fetch_submodules=fetch_submodules
    )
    return {
        "owner": repo_hash.repository.owner,
        "repo": repo_hash.repository.name,
        "rev": repo_hash.rev,
        "sha256": repo_hash.sha256,
        "fetchSubmodules": repo_hash.fetch_submodules,
    }


def get_repo_hash(fetcher="fetchFromGitHub", **kwargs):
    if fetcher == "fetchFromGitHub":
        return get_repo_hash_fetchFromGitHub(**kwargs)
    else:
        raise ValueError(f"Unsupported fetcher: {fetcher}")


def get_repo_hashes(cores_to_update=[]):
    with open(HASHES_PATH) as f:
        repo_hashes = json.loads(f.read())

    for core, repo in CORES.items():
        if core in cores_to_update:
            info(f"Getting repo hash for '{core}'...")
            repo_hashes[core] = get_repo_hash(**repo)
        else:
            info(f"Skipping '{core}'...")

    return repo_hashes


def main():
    # If you don't want to update all cores, pass the name of the cores you
    # want to update on the command line. E.g.:
    # $ ./update.py citra snes9x
    if len(sys.argv) > 1:
        cores_to_update = sys.argv[1:]
    else:
        cores_to_update = CORES.keys()

    repo_hashes = get_repo_hashes(cores_to_update)
    info(f"Generating '{HASHES_PATH}'...")
    with open(HASHES_PATH, "w") as f:
        f.write(json.dumps(dict(sorted(repo_hashes.items())), indent=4))
        f.write("\n")
    info("Finished!")


if __name__ == "__main__":
    main()
