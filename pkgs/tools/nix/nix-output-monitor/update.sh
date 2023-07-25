#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix curl jq alejandra
#
# This script will update the nix-output-monitor derivation to the latest version using
# cabal2nix.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

derivation_file="${script_dir}/generated-package.nix"

# This is the latest released version of nix-output-monitor on GitHub.
new_version=$(curl --silent "https://api.github.com/repos/maralorn/nix-output-monitor/releases" | jq '.[0].tag_name' --raw-output)

echo "Updating nix-output-monitor to version $new_version."
echo "Running cabal2nix and outputting to ${derivation_file}..."

cat > "$derivation_file" << EOF
# This file has been autogenerate with cabal2nix.
# Update via ./update.sh"
EOF

cabal2nix \
  --maintainer maralorn \
  "https://github.com/maralorn/nix-output-monitor/archive/refs/tags/${new_version}.tar.gz" \
  >> "$derivation_file"

alejandra "${derivation_file}" | cat

echo "Finished."
