#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils moreutils curl jq nix-prefetch-git cargo gnugrep gawk
# shellcheck shell=bash

set -euo pipefail

srcJson="$(realpath "./pkgs/os-specific/linux/scx/version.json")"
srcFolder="$(dirname "$srcJson")"

localVer=$(jq -r .version <$srcJson)
latestVer=$(curl -s https://api.github.com/repos/sched-ext/scx/releases/latest | jq -r .tag_name | sed 's/v//g')

if [ "$localVer" == "$latestVer" ]; then
  exit 0
fi

latestHash=$(nix-prefetch-git https://github.com/sched-ext/scx.git --rev refs/tags/v$latestVer --quiet | jq -r .hash)

tmp=$(mktemp -d)
trap 'rm -rf -- "${tmp}"' EXIT

git clone --depth 1 --branch "v$latestVer" https://github.com/sched-ext/scx.git "$tmp/scx"

pushd "$tmp/scx"

bpftoolRev=$(grep 'bpftool_commit =' ./meson.build | awk -F"'" '{print $2}')
bpftoolHash=$(nix-prefetch-git https://github.com/libbpf/bpftool.git --rev $bpftoolRev --fetch-submodules --quiet | jq -r .hash)

libbpfRev=$(curl -s "https://api.github.com/repos/libbpf/libbpf/commits/master" | jq -r '.sha')
libbpfHash=$(nix-prefetch-git https://github.com/libbpf/libbpf.git --rev $libbpfRev --fetch-submodules --quiet | jq -r .hash)

jq \
  --arg latestVer "$latestVer" --arg latestHash "$latestHash" \
  --arg bpftoolRev "$bpftoolRev" --arg bpftoolHash "$bpftoolHash" \
  --arg libbpfRev "$libbpfRev" --arg libbpfHash "$libbpfHash" \
  ".scx.version = \$latestVer | .scx.hash = \$latestHash |\
  .bpftool.rev = \$bpftoolRev | .bpftool.hash = \$bpftoolHash |\
  .libbpf.rev = \$libbpfRev | .libbpf.hash = \$libbpfHash" \
  "$srcJson" | sponge $srcJson

rm -f Cargo.toml Cargo.lock

pushd scheds/rust
for scheduler in bpfland lavd layered rlfifo rustland; do
  pushd "scx_$scheduler"

  cargo generate-lockfile
  cp Cargo.lock "$srcFolder/scx_$scheduler/Cargo.lock"

  popd
done
