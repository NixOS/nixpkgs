#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused gnupg common-updater-scripts

set -eu -o pipefail

version="$(curl -s https://api.github.com/repos/bisq-network/bisq/releases| jq '.[] | {name,prerelease} | select(.prerelease==false) | limit(1;.[])' | sed 's/[\"v]//g' | head -n 1)"
depname="Bisq-64bit-$version.deb"
src="https://github.com/bisq-network/bisq/releases/download/v$version/$depname"
signature="$src.asc"
key="CB36 D7D2 EBB2 E35D 9B75 500B CD5D C1C5 29CD FD3B"

pushd $(mktemp -d --suffix=-bisq-updater)
export GNUPGHOME=$PWD/gnupg
mkdir -m 700 -p "$GNUPGHOME"
curl -L -o "$depname" -- "$src"
curl -L -o signature.asc -- "$signature"
gpg --batch --recv-keys "$key"
gpg --batch --verify signature.asc "$depname"
sha256=$(nix-prefetch-url --type sha256 "file://$PWD/$depname")
popd

update-source-version bisq-desktop "$version" "$sha256"
