#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../ -i bash -p wget yarn2nix-moretea.yarn2nix

# This script is based upon:
# pkgs/applications/networking/instant-messengers/riot/update-riot-desktop.sh

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
	echo "Regenerates the Yarn dependency lock files for the gotify-server package."
	echo "Usage: $0 <git release tag>"
	exit 1
fi

GOTIFY_WEB_SRC="https://raw.githubusercontent.com/gotify/server/$1"

wget "$GOTIFY_WEB_SRC/ui/package.json" -O package.json
wget "$GOTIFY_WEB_SRC/ui/yarn.lock" -O yarn.lock
yarn2nix --lockfile=yarn.lock > yarndeps.nix
rm yarn.lock
