#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix curl jq
#
# This script will update the dconf2nix derivation to the latest version using
# cabal2nix.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# dconf2nix derivation created with cabal2nix.
dconf2nix_derivation_file="${script_dir}/dconf2nix.nix"

# This is the current revision of dconf2nix in Nixpkgs.
old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$dconf2nix_derivation_file")"

# This is the latest release version of dconf2nix on GitHub.
new_version=$(curl --silent "https://api.github.com/repos/gvolpe/dconf2nix/releases" | jq '.[0].tag_name' --raw-output)

echo "Updating dconf2nix from old version $old_version to new version $new_version."
echo "Running cabal2nix and outputting to ${dconf2nix_derivation_file}..."

cabal2nix --revision "$new_version" "https://github.com/gvolpe/dconf2nix.git" > "$dconf2nix_derivation_file"

echo "Finished."
