#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix-prefetch-github python3Packages.requests

from nix_prefetch_github import *
import json
import requests
import subprocess

REPOS = [ "libime", "xcb-imdkit", "fcitx5", "fcitx5-gtk", "fcitx5-qt", "fcitx5-configtool", "fcitx5-lua",
          "fcitx5-rime", "fcitx5-chinese-addons", "fcitx5-table-extra", "fcitx5-table-other" ]

OWNER = "fcitx"

def get_latest_tag(repo, owner=OWNER):
    r = requests.get( 'https://api.github.com/repos/{}/{}/tags'.format(owner,repo)
                    , auth=('poscat', 'db5e6fd16d0eb8c36385d3d944e058a1178b4265'))
    return r.json()[0].get("name")

def main():
    sources = dict()
    for repo in REPOS:
        rev = get_latest_tag(repo)
        if repo == "fcitx5-qt":
            subprocess.run(["nix-update", "--commit", "--version", rev, "libsForQt5.{}".format(repo)])
        else:
            subprocess.run(["nix-update", "--commit", "--version", rev, repo])

if __name__ == "__main__":
    main ()
