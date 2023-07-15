#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix nodejs_18 gnused wget

# Usage: ./generate-dependencies.sh <version>
# Use the same version format as in ./default.nix (without the 'v')

set -eou pipefail

version=$1


echo "Karma version: $version"
cd "$(dirname $(readlink -f $0))"

wget -O ./package-lock.json https://raw.githubusercontent.com/prymitive/karma/v$version/ui/package-lock.json
wget -O ./package.json https://raw.githubusercontent.com/prymitive/karma/v$version/ui/package.json

sed -i -e 's/"name": "ui",/"name": "karma-ui",/g' ./package.json
sed -i -e 's/"name": "ui",/"name": "karma-ui",/g' ./package-lock.json

node2nix \
    --nodejs-18 \
    --development \
    -l ./package-lock.json \
    -i ./package.json \
    -o ./node-packages.nix \
    -c ./node-composition.nix \
    -e ./node-env.nix

rm package-lock.json
