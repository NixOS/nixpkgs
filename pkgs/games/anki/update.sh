#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git wget jq common-updater-scripts yarn-berry_4 yarn-berry_4.yarn-berry-fetcher tomlq

set -eu -o pipefail
set -x

TMPDIR=/tmp/anki-update-script

cleanup() {
  if [ -e $TMPDIR/.done ]; then
    rm -rf "$TMPDIR"
  else
    echo
    read -p "Script exited prematurely. Do you want to delete the temporary directory $TMPDIR ? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf "$TMPDIR"
    fi
  fi
}

trap cleanup EXIT

scriptDir="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
cd "$scriptDir"

if [[ "$#" > 2 ]]; then
  tag="$2"
else
  tag="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s 'https://api.github.com/repos/ankitects/anki/releases' | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')"
fi

nixpkgs="$(git rev-parse --show-toplevel)"

ver=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).anki.version" | tr -d '"')

mkdir -p $TMPDIR
pushd $TMPDIR

curl -o yarn.lock "https://raw.githubusercontent.com/ankitects/anki/refs/tags/$ver/yarn.lock"

echo "Generating missing-hashes.json"
yarn-berry-fetcher missing-hashes yarn.lock > missing-hashes.json
if [[ -f missing-hashes.json ]]; then
  YARN_HASH=$(yarn-berry-fetcher prefetch yarn.lock missing-hashes.json)
else
  YARN_HASH=$(yarn-berry-fetcher prefetch yarn.lock)
fi

if [[ -f missing-hashes.json ]]; then
  echo "Copying missing-hashes.json back into nixpkgs"
  cp missing-hashes.json "$nixpkgs/pkgs/games/anki"
fi

sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$YARN_HASH\"#" ${scriptDir}/default.nix

echo "yarnHash updated"
echo "Regenerating uv-deps.json"


curl -o uv.lock "https://raw.githubusercontent.com/ankitects/anki/refs/tags/$ver/uv.lock"
tq -f ./uv.lock --output json '.' | jq '.. | objects | .url | select(. != null)' -cr > uv.urls

echo '[' > uv-deps.json
for url in $(cat uv.urls); do
  urlHash="$(nix-prefetch-url --type sha256 "$url")"
  echo '{"url": "'$url'", "hash": "'$(nix-hash --type sha256 --to-sri $urlHash)'"},' >> uv-deps.json
done
# strip final trailing comma
sed '$s/,$//' -i uv-deps.json
echo ']' >> uv-deps.json

# and jq format it on the way into nixpkgs too
jq '.' uv-deps.json > "$nixpkgs/pkgs/games/anki/uv-deps.json"
echo "Wrote uv-deps.json"

popd

update-source-version anki "$newest_version" --print-changes
touch $TMPDIR/.done
