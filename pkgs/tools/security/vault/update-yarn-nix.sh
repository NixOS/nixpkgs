#/usr/bin/env nix-shell
#! nix-shell -i bash -p yarn2nix

# Usage:
#    NIX_PATH=nixpkgs=<your local nixpkgs checkout> ./update-yarn-nix.sh

# Download an unpack URL
src="$(nix-build '<nixpkgs>' -A vault.src --no-out-link)"
tmp="$(mktemp)"
chmod u+w "${tmp}"
cp "${src}/ui/yarn.lock" "$tmp"
yarn2nix --lockfile "${tmp}" > yarn.nix
