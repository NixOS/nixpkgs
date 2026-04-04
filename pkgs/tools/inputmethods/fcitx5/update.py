#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix-update python3Packages.requests

import requests
import subprocess

REPOS = [
        ( "fcitx", "libime" ),
        ( "fcitx", "xcb-imdkit"),

        ( "fcitx", "fcitx5" ),
        ( "fcitx", "fcitx5-anthy" ),
        ( "fcitx", "fcitx5-chewing" ),
        ( "fcitx", "fcitx5-chinese-addons" ),
        ( "fcitx", "fcitx5-configtool" ),
        ( "fcitx", "fcitx5-gtk" ),
        ( "fcitx", "fcitx5-hangul" ),
        ( "fcitx", "fcitx5-lua" ),
        ( "fcitx", "fcitx5-m17n" ),
        ( "fcitx", "fcitx5-qt" ),
        ( "fcitx", "fcitx5-rime" ),
        ( "fcitx", "fcitx5-skk" ),
        ( "fcitx", "fcitx5-table-extra" ),
        ( "fcitx", "fcitx5-table-other" ),
        ( "fcitx", "fcitx5-unikey" ),
        ( "fcitx", "fcitx5-unikey" )

        ( "ray2501", "fcitx5-array" )
        ]

OWNER = "fcitx"

def get_latest_tag(repo, owner=OWNER):
    r = requests.get('https://api.github.com/repos/{}/{}/tags'.format(owner,repo))
    return r.json()[0].get("name")

def main():
    for (owner, repo) in REPOS:
        rev = get_latest_tag(repo, owner)
        if repo == "fcitx5-qt":
            subprocess.run(["nix-update", "--commit", "--version", rev, "qt6Packages.{}".format(repo)])
        else:
            subprocess.run(["nix-update", "--commit", "--version", rev, repo])

if __name__ == "__main__":
    main ()
