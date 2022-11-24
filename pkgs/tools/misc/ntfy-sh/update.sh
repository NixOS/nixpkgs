#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix curl jq nix

set -euo pipefail
# cd to the folder containing this script
cd "$(dirname "$0")"

CURRENT_VERSION=$(nix-instantiate ../../../../. --eval --strict -A ntfy-sh.version | tr -d '"')
TARGET_VERSION="$(curl -sL https://api.github.com/repos/binwiederhier/ntfy/releases/latest | jq --exit-status -r ".tag_name")"

if [[ "v$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
    echo "ntfy-sh is up-to-date: ${CURRENT_VERSION}"
    exit 0
fi

echo "ntfy-sh: $CURRENT_VERSION -> $TARGET_VERSION"

rm -f package.json package-lock.json
curl -sLO https://github.com/binwiederhier/ntfy/raw/$TARGET_VERSION/web/package.json
curl -sL -o package-lock-temp.json https://github.com/binwiederhier/ntfy/raw/$TARGET_VERSION/web/package-lock.json

./generate-dependencies.sh

rm ./package-lock-temp.json
