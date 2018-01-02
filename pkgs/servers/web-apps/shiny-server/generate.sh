#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix curl jshon
# This script is based on generate.sh from the pump.io package.
set -e

VERSION=v1.5.5.872 
SHA256=16r034h8cgrfxkyj4racpg0pccgl7yl7p9bpdd4yf0m9arx6j49d
URL="https://github.com/rstudio/shiny-server.git"

curl -O -L https://raw.githubusercontent.com/rstudio/shiny-server/$VERSION/package.json

node2nix --input package.json \
         --composition composition.nix \
         --node-env ../../../development/node-packages/node-env.nix

# Overriding nodePackages src doesn't work
# (https://github.com/svanderburg/node2nix/issues/31).
SRC="fetchgit { url = \"$URL\"; rev = \"$VERSION\"; sha256 = \"$SHA256\";}"
sed -i "s|src = ./.|src = $SRC|" node-packages.nix
