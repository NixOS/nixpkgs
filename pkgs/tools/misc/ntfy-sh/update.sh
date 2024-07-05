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
