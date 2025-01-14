#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update jq

set -xeuo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
NIXPKGS_DIR=$(readlink -f "$SCRIPT_DIR/../../../..")
cd "$NIXPKGS_DIR"

nix_versions=$(nix eval --impure --json --expr "with import ./. { config.allowAliases = false; }; builtins.filter (name: builtins.match \"nix_.*\" name != null) (builtins.attrNames nixVersions)" | jq -r '.[]')
for name in $nix_versions; do
    minor_version=${name#nix_*_}
    if [[ "$name" = "nix_2_3" ]]; then # not maintained by the nix team
        continue
    fi
    nix-update --override-filename "$SCRIPT_DIR/default.nix" --version-regex "(2\\.${minor_version}\..+)" --build --commit "nixVersions.$name"
done

commit_json=$(curl -s https://api.github.com/repos/NixOS/nix/commits/master) # format: 2024-11-01T10:18:53Z
date_of_commit=$(echo "$commit_json" | jq -r '.commit.author.date')
suffix="pre$(date -d "$date_of_commit" +%Y%m%d)_"
sed -i -e "s|\"pre[0-9]\{8\}_|\"$suffix|g" "$SCRIPT_DIR/default.nix"
nix-update --override-filename "$SCRIPT_DIR/default.nix" --version branch --build --commit "nixVersions.git"
