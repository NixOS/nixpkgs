#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

version="$(curl -sL "https://api.github.com/repos/HexFiend/HexFiend/releases/latest" | jq -r ".tag_name" | sed 's/^v//')"
update-source-version hexfiend "$version"
