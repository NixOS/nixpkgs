#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../. -i bash -p common-updater-scripts internetarchive

set -eo pipefail

new_version=$(curl --silent https://releases.raycast.com/releases/latest | jq -r '.version')
old_version=$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)

if [[ $new_version == $old_version ]]; then
    echo "Already up to date."
    exit 0
else
    echo "raycast: $old_version -> $new_version"
    sed -Ei.bak '/ *version = "/s/".+"/"'"$new_version"'"/' ./default.nix
    rm ./default.nix.bak
fi

hash=$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://releases.raycast.com/releases/$new_version/download?build=universal" | jq -r '.hash')
sed -Ei.bak '/ *sha256 = /{N;N; s@("sha256-)[^;"]+@"'"$hash"'@}' ./default.nix
rm ./default.nix.bak
