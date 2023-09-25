#!/bin/bash -e

URL_BASE="${1-http://localhost:8000}"
OUT_DIR="${2-.}"
SELF_DIRNAME="$(dirname $(realpath $0))"
export NIX_PATH="$SELF_DIRNAME/../../../.."

for PLATFORM in x86_64-freebsd14; do
    echo "    ${PLATFORM} = {"
    for PROGRAM in bash mkdir tar unxz chmod bootstrapFiles; do
    STORE_PATH="$(nix-build --quiet --no-out-link --argstr system ${PLATFORM} ${SELF_DIRNAME}/bootstrap-files/${PROGRAM}.nix)"
    BASENAME="$(basename $STORE_PATH)"
    if [[ "$PROGRAM" = "bootstrapFiles" ]]; then
        HASH="$(nix-hash --type sha256 --to-sri $(sha256sum $STORE_PATH | awk '{ print $1 }'))"
    else
        HASH="$(nix-hash --type sha256 --sri $STORE_PATH)"
    fi
    ln -sf "${STORE_PATH}" "${OUT_DIR}/${BASENAME}"
    echo "      ${PROGRAM} = {"
    echo "        url = \"${URL_BASE}/${BASENAME}\";"
    echo "        hash = \"$HASH\";"
    echo "      };"
    done
    echo "    };"
done
