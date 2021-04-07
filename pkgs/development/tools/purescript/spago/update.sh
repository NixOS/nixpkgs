#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix curl jq
#
# This script will update the spago derivation to the latest version using
# cabal2nix.
#
# Note that you should always try building spago after updating it here, since
# some of the overrides in pkgs/development/haskell/configuration-nix.nix may
# need to be updated/changed.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Spago derivation created with cabal2nix.
spago_derivation_file="${script_dir}/spago.nix"

# This is the current revision of spago in Nixpkgs.
old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$spago_derivation_file")"

# This is the latest release version of spago on GitHub.
new_version=$(curl --silent "https://api.github.com/repos/purescript/spago/releases" | jq '.[0].tag_name' --raw-output)

echo "Updating spago from old version $old_version to new version $new_version."
echo "Running cabal2nix and outputting to ${spago_derivation_file}..."

cabal2nix --revision "$new_version" "https://github.com/purescript/spago.git" > "$spago_derivation_file"

# TODO: This should ideally also automatically update the docsSearchVersion
# from pkgs/development/haskell/configuration-nix.nix.

echo "Finished."
