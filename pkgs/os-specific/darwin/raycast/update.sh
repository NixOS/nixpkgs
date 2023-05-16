#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -I nixpkgs=../../../../. -i bash -p common-updater-scripts jq

set -eo pipefail

new_version=$(curl --silent https://releases.raycast.com/releases/latest?build=universal | jq -r '.version')
old_version=$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)

if [[ $new_version == $old_version ]]; then
=======
#!nix-shell -I nixpkgs=../../../../. -i bash -p common-updater-scripts internetarchive

set -eo pipefail

new_version="$(ia list raycast | grep -Eo '^raycast-.*\.dmg$' | sort -r | head -n1 | sed -E 's/^raycast-([0-9]+\.[0-9]+\.[0-9]+)\.dmg$/\1/')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    echo "Already up to date."
    exit 0
else
    echo "raycast: $old_version -> $new_version"
    sed -Ei.bak '/ *version = "/s/".+"/"'"$new_version"'"/' ./default.nix
    rm ./default.nix.bak
fi

<<<<<<< HEAD
hash=$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://releases.raycast.com/releases/$new_version/download?build=universal" | jq -r '.hash')
sed -Ei.bak '/ *hash = /{N;N; s@("sha256-)[^;"]+@"'"$hash"'@}' ./default.nix
=======
hash="$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://archive.org/download/raycast/raycast-$new_version.dmg" | jq -r '.hash')"
sed -Ei.bak '/ *sha256 = /{N;N; s@("sha256-)[^;"]+@"'"$hash"'@}' ./default.nix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
rm ./default.nix.bak
