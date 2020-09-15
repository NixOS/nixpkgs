#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coursier curl gnused gawk

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/default.nix" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

BLOOP_VER=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/scalacenter/bloop/releases/latest | awk -F'/v' '{print $NF}')
sed -i "s/version = \".*\"/version = \"${BLOOP_VER}\"/" "$ROOT/default.nix"

BLOOP_CHANNEL_URL="https://github.com/scalacenter/bloop/releases/download/v${BLOOP_VER}/bloop-coursier.json"
BLOOP_CHANNEL_SHA256=$(nix-prefetch-url ${BLOOP_CHANNEL_URL})
sed -i "17s/sha256 = \".*\"/sha256 = \"${BLOOP_CHANNEL_SHA256}\"/" "$ROOT/default.nix"

BLOOP_BASH_URL="https://github.com/scalacenter/bloop/releases/download/v${BLOOP_VER}/bash-completions"
BLOOP_BASH_SHA256=$(nix-prefetch-url ${BLOOP_BASH_URL})
sed -i "22s/sha256 = \".*\"/sha256 = \"${BLOOP_BASH_SHA256}\"/" "$ROOT/default.nix"

BLOOP_FISH_URL="https://github.com/scalacenter/bloop/releases/download/v${BLOOP_VER}/fish-completions"
BLOOP_FISH_SHA256=$(nix-prefetch-url ${BLOOP_FISH_URL})
sed -i "27s/sha256 = \".*\"/sha256 = \"${BLOOP_FISH_SHA256}\"/" "$ROOT/default.nix"

BLOOP_ZSH_URL="https://github.com/scalacenter/bloop/releases/download/v${BLOOP_VER}/zsh-completions"
BLOOP_ZSH_SHA256=$(nix-prefetch-url ${BLOOP_ZSH_URL})
sed -i "32s/sha256 = \".*\"/sha256 = \"${BLOOP_ZSH_SHA256}\"/" "$ROOT/default.nix"

# Temporary work dir to calculate hashes
WORKDIR="/tmp/coursier-build"
mkdir -p ${WORKDIR}
export COURSIER_CACHE=${WORKDIR}
export COURSIER_JVM_CACHE=${WORKDIR}

curl --create-dirs -L -q -o "${WORKDIR}/channel/bloop.json" ${BLOOP_CHANNEL_URL}

coursier install --install-dir "${WORKDIR}/linux" --install-platform "x86_64-pc-linux" --default-channels=false --channel "${WORKDIR}/channel" --only-prebuilt=true bloop
sed -i '5,$ d' "${WORKDIR}/linux/bloop"
BLOOP_LINUX_SHA256=$(nix-hash --type sha256 --base32 ${WORKDIR}/linux)
sed -i "57s/\".*\"/\"${BLOOP_LINUX_SHA256}\"/" "$ROOT/default.nix"

coursier install --install-dir "${WORKDIR}/osx" --install-platform "x86_64-apple-darwin" --default-channels=false --channel "${WORKDIR}/channel" --only-prebuilt=true bloop
sed -i '5,$ d' "${WORKDIR}/osx/bloop"
BLOOP_DARWIN_SHA256=$(nix-hash --type sha256 --base32 ${WORKDIR}/osx)
sed -i "58s/\".*\"/\"${BLOOP_DARWIN_SHA256}\"/" "$ROOT/default.nix"

# Clean temporary work dir
rm -r ${WORKDIR}
