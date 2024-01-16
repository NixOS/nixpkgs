#!/usr/bin/env bash
# Legacy script, can be removed once the PR removing its use is merged.
# It's not used anymore because CI and local runs both use pinned-tool.json as their source of truth now,
# though in different ways since local runs need to support arbitrary platforms

# Try to not use nix-shell here to avoid fetching Nixpkgs,
# especially since this is used in CI
# The only dependency is `jq`, which in CI is implicitly available
# And when run from ./run-local.sh is provided by that parent script

set -o pipefail -o errexit -o nounset

trace() { echo >&2 "$@"; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pin_file=$SCRIPT_DIR/pinned-tool.json

if (( $# < 1 )); then
    trace "Usage: $0 fetch OUTPUT_PATH"
    trace "OUTPUT_PATH: The output symlink path for the tool"
    exit 1
fi
output=$1

trace "Reading $pin_file.. "
rev=$(jq -r .rev "$SCRIPT_DIR"/pinned-tool.json)
trace -e "Git revision is \e[34m$rev\e[0m"
path=$(jq -r '."ci-path"' "$SCRIPT_DIR"/pinned-tool.json)
trace "Tooling path is $path"

trace -n "Fetching the prebuilt version of nixpkgs-check-by-name.. "
nix-store --add-root "$output" -r "$path" >/dev/null
realpath "$output"
