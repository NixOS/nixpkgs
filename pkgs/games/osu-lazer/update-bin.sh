#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../. -i bash -p unzip curl jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

bin_file="$(realpath ./bin.nix)"

new_version="$(curl -s "https://api.github.com/repos/ppy/osu/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./bin.nix)"
if [[ "$new_version" == "$old_version" ]]; then
    echo "Already up to date."
    exit 0
fi

cd ../../..

echo "Updating osu-lazer-bin from $old_version to $new_version..."
sed -Ei.bak '/ *version = "/s/".+"/"'"$new_version"'"/' "$bin_file"
rm "$bin_file.bak"

for pair in \
    'aarch64-darwin osu.app.Apple.Silicon.zip' \
    'x86_64-darwin osu.app.Intel.zip' \
    'x86_64-linux osu.AppImage'; do
    set -- $pair
    echo "Prefetching binary for $1..."
    prefetch_output=$(nix --extra-experimental-features nix-command store prefetch-file --json --hash-type sha256 "https://github.com/ppy/osu/releases/download/$new_version/$2")
    if [[ "$1" == *"darwin"* ]]; then
        store_path=$(jq -r '.storePath' <<<"$prefetch_output")
        tmpdir=$(mktemp -d)
        unzip -q "$store_path" -d "$tmpdir"
        hash=$(nix --extra-experimental-features nix-command hash path "$tmpdir")
        rm -r "$tmpdir"
    else
        hash=$(jq -r '.hash' <<<"$prefetch_output")
    fi
    echo "$1 ($2): sha256 = $hash"
    sed -Ei.bak '/ *'"$1"' = /{N;N; s@("sha256-)[^;"]+@"'"$hash"'@}' "$bin_file"
    rm "$bin_file.bak"
done
