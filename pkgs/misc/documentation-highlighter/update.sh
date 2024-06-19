#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl -p unzip

set -eu
set -o pipefail

root=$(pwd)

if [ ! -f "./update.sh" ]; then
    echo "Please run this script from within pkgs/misc/documentation-highlighter/!"
    exit 1
fi

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish {
  rm -rf "$scratch"
}
trap finish EXIT


mkdir $scratch/src
cd $scratch/src

curl \
    -X POST \
    -H 'Content-Type: application/json' \
    --data-raw '{
      "api": 2,
      "languages": ["bash", "nix", "shell"]
    }' \
    https://highlightjs.org/api/download > $scratch/out.zip


unzip "$scratch/out.zip"
out="$root/"
mkdir -p "$out"
cp ./highlight.min.js "$out/highlight.pack.js"
cp ./{LICENSE,styles/mono-blue.css} "$out"

(
    echo "This file was generated with pkgs/misc/documentation-highlighter/update.sh"
    echo ""
    cat README.md
) > "$out/README.md"
