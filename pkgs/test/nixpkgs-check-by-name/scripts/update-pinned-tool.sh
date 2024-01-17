#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq

set -o pipefail -o errexit -o nounset

trace() { echo >&2 "$@"; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

channel=nixos-unstable
pin_file=$SCRIPT_DIR/pinned-tool.json

trace -n "Fetching latest version of channel $channel.. "
# This is probably the easiest way to get Nix to output the path to a downloaded channel!
nixpkgs=$(nix-instantiate --find-file nixpkgs -I nixpkgs=channel:"$channel")
trace "$nixpkgs"

# This file only exists in channels
rev=$(<"$nixpkgs/.git-revision")
trace -e "Git revision of channel $channel is \e[34m$rev\e[0m"


trace -n "Fetching the prebuilt version of nixpkgs-check-by-name.. "
path=$(nix-build --no-out-link "$nixpkgs" -A tests.nixpkgs-check-by-name -j 0 | tee /dev/stderr)

trace "Updating $pin_file"
jq -n \
    --arg rev "$rev" \
    --arg path "$path" \
    '$ARGS.named' \
    > "$pin_file"
