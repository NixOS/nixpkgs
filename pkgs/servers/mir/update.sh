#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq common-updater-scripts

set -eou pipefail

version="$(curl --silent "https://api.github.com/repos/canonical/mir/tags" | jq '.[0].name' --raw-output)"

update-source-version mir "${version:1}" --file=./pkgs/servers/mir/default.nix
