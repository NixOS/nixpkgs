#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../.. -i bash -p curl jq common-updater-scripts prefetch-npm-deps nodejs
set -eou pipefail

tempDir=$(mktemp -d)

ghTags=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/Vendicated/Vencord/tags")
latestTag=$(echo "$ghTags" | jq -r .[0].name)
gitHash=$(echo "$ghTags" | jq -r .[0].commit.sha)

pushd "$tempDir"
curl "https://raw.githubusercontent.com/Vendicated/Vencord/$latestTag/package.json" -o package.json
npm install --legacy-peer-deps -f

npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
popd

pushd ../../..
update-source-version vencord "${latestTag#v}"
popd

sed -E 's#\bgitHash = ".*?"#gitHash = "'"${gitHash:0:7}"'"#' -i default.nix
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i default.nix
cp "$tempDir/package-lock.json" package-lock.json
