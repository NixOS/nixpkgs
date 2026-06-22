#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

update-source-version beatoraja-bin.unwrapped $(grep -Eo '[0-9]+\.[0-9]+\.[0-9]' <(curl -s 'https://mocha-repository.info/download.php') | head -n 1)
