#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

TARGET_VERSION=$(curl -s "https://api.github.com/repos/mattpannella/pocket-updater-utility/releases?per_page=1" | jq -r '.[0].tag_name')

if [[ "$UPDATE_NIX_OLD_VERSION" == "$TARGET_VERSION" ]]; then
  echo "pocket-updater-utility is up-to-date: ${UPDATE_NIX_OLD_VERSION}"
  exit 0
fi

update-source-version pocket-updater-utility "$TARGET_VERSION"
