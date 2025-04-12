#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl xq-xml common-updater-scripts
set -euo pipefail

OLD_VERSION="$(nix-instantiate --eval --json --expr 'let pkgs = import ./. {}; in pkgs._7zz.version' | sed 's/"//g')"
NEW_VERSION="$(curl -H 'Accept: application/rss+xml' 'https://sourceforge.net/projects/sevenzip/rss?path=/7-Zip' | xq -x "substring((/rss/channel/item[link[contains(., 'src.tar.xz')]])[1]/title, 8, 5)")"

echo "comparing versions $OLD_VERSION => $NEW_VERSION"
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date! Doing nothing"
    exit 0
fi

update-source-version _7zz "$NEW_VERSION"
update-source-version _7zz-rar "$NEW_VERSION" --ignore-same-version
