#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../.. -i bash -p wget yarn2nix-moretea.yarn2nix

# This script is based upon:
# pkgs/applications/networking/instant-messengers/riot/update-riot-desktop.sh

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
        echo "Regenerates the Yarn dependency lock files for the prometheus package."
        echo "Usage: $0 <git release tag>"
        exit 1
fi

PROM_WEB_SRC="https://raw.githubusercontent.com/prometheus/prometheus/$1"

wget "$PROM_WEB_SRC/web/ui/react-app/package.json" -O webui-package.json
wget "$PROM_WEB_SRC/web/ui/react-app/yarn.lock" -O yarn.lock
yarn2nix --lockfile=yarn.lock > webui-yarndeps.nix
rm yarn.lock
