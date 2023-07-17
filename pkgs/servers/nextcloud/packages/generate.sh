#!/usr/bin/env nix-shell
#!nix-shell nc4nix-shell.nix -i bash

set -e
set -u
set -o pipefail
set -x

echo "versions: $NEXTCLOUD_VERSIONS"

APPS=$(jq -r '.[]' "$SCRIPT_FOLDER"/nextcloud-apps.json | sed -z 's/\n/,/g;s/,$/\n/')

# nc4nix needs NEXTCLOUD_VERSIONS
nc4nix -apps "$APPS"
rm ./*.log
