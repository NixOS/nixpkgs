#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i bash -p wget yarn2nix
# shellcheck shell=bash

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
    echo "Regenerates the Yarn dependency lock files for the influxdb UI."
    echo "Usage: $0 <git release tag>"
    exit 1
fi

INFLUXDB_SRC="https://raw.githubusercontent.com/influxdata/influxdb/$1"

wget "$INFLUXDB_SRC/ui/package.json" -O influx-ui-package.json
wget "$INFLUXDB_SRC/ui/yarn.lock" -O influx-ui-yarndeps.lock
yarn2nix --lockfile=influx-ui-yarndeps.lock > influx-ui-yarndeps.nix
rm influx-ui-yarndeps.lock
