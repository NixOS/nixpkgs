#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep coreutils curl wget jq nix-update prefetch-yarn-deps

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

owner="pomerium"
repo="pomerium"
version=`curl -s "https://api.github.com/repos/$owner/$repo/tags" | jq -r .[0].name | grep -oP "^v\K.*"`
url="https://raw.githubusercontent.com/$owner/$repo/v$version/"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

rm -f package.json yarn.lock
wget "$url/ui/yarn.lock" "$url/ui/package.json"
echo $(prefetch-yarn-deps) > yarn-hash
rm -f yarn.lock

popd
nix-update pomerium --version $version
