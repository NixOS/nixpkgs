<<<<<<< HEAD
#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep gnused coreutils curl wget jq nix-update prefetch-npm-deps nodejs

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(curl -s "https://api.github.com/repos/binwiederhier/ntfy/tags" | jq -r .[0].name | grep -oP "^v\K.*")
url="https://raw.githubusercontent.com/binwiederhier/ntfy/v$version/"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

rm -f package-lock.json
wget "$url/web/package-lock.json"
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' default.nix
rm -f package-lock.json

popd
nix-update ntfy-sh --version $version
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
