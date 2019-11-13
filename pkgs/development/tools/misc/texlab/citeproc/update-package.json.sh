#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq

set -eu -o pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
	echo "Usage: $0 <git release tag>"
	exit 1
fi

TEXLAB_WEB_SRC="https://raw.githubusercontent.com/latex-lsp/texlab/$1"

curl --silent "$TEXLAB_WEB_SRC/src/citeproc/js/package.json" | \
	jq '. + {"dependencies": .devDependencies} | del(.devDependencies)' > package.json
