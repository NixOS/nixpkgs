#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl

set -o pipefail -o errexit -o nounset

trace() { echo >&2 "$@"; }

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

repository=NixOS/nixpkgs-check-by-name
pin_file=$SCRIPT_DIR/pinned-version.txt

trace -n "Fetching latest release of $repository.. "
latestRelease=$(curl -sSfL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/"$repository"/releases/latest)
latestVersion=$(jq .tag_name -r <<< "$latestRelease")
trace "$latestVersion"

trace "Updating $pin_file"
echo "$latestVersion" > "$pin_file"
