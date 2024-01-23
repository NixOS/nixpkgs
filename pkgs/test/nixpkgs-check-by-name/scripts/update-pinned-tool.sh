#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq -I nixpkgs=../../../..

set -o pipefail -o errexit -o nounset

trace() { echo >&2 "$@"; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Determined by `runs-on: ubuntu-latest` in .github/workflows/check-by-name.yml
CI_SYSTEM=x86_64-linux

channel=nixos-unstable
pin_file=$SCRIPT_DIR/pinned-tool.json

trace -n "Fetching latest version of channel $channel.. "
# This is probably the easiest way to get Nix to output the path to a downloaded channel!
nixpkgs=$(nix-instantiate --find-file nixpkgs -I nixpkgs=channel:"$channel")
trace "$nixpkgs"

# This file only exists in channels
rev=$(<"$nixpkgs/.git-revision")
trace -e "Git revision of channel $channel is \e[34m$rev\e[0m"

trace -n "Fetching the prebuilt version of nixpkgs-check-by-name for $CI_SYSTEM.. "
# This is the architecture used by CI, we want to prefetch the exact path to avoid having to evaluate Nixpkgs
ci_path=$(nix-build --no-out-link "$nixpkgs" \
    -A tests.nixpkgs-check-by-name \
    --arg config '{}' \
    --argstr system "$CI_SYSTEM" \
    --arg overlays '[]' \
    -j 0 \
    | tee /dev/stderr)

trace "Updating $pin_file"
jq -n \
    --arg rev "$rev" \
    --arg ci-path "$ci_path" \
    '$ARGS.named' \
    > "$pin_file"
