#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils common-updater-scripts

latestVersion=$(curl "https://api.github.com/repos/archimatetool/archi/tags" | jq -r '.[0].name' | tail -c +9)
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; archi.version or (lib.getVersion archi)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash_aarch64_darwin=$(nix-prefetch-url https://www.archimatetool.com/downloads/archi_5.php?/$latestVersion/Archi-Mac-Silicon-$latestVersion.dmg)
hash_x86_64_darwin=$(nix-prefetch-url https://www.archimatetool.com/downloads/archi_5.php?/$latestVersion/Archi-Mac-$latestVersion.dmg)
hash_x86_64_linux=$(nix-prefetch-url https://www.archimatetool.com/downloads/archi_5.php?/$latestVersion/Archi-Linux64-$latestVersion.tgz)

update-source-version archi 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system=aarch64-darwin
update-source-version archi $latestVersion $hash_aarch64_darwin --system=aarch64-darwin
update-source-version archi 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system=x86_64-darwin
update-source-version archi $latestVersion $hash_x86_64_darwin --system=x86_64-darwin
update-source-version archi 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system=x86_64-linux
update-source-version archi $latestVersion $hash_x86_64_linux --system=x86_64-linux

