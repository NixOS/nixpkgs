#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")" || exit

repo="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"
latestTag="$(git ls-remote --refs --tags --sort refname "$repo" | tail -n1 | cut -f2 | cut -d '/' -f3)"

snapshotUrl="$repo/snapshot/linux-firmware-$latestTag.tar.gz"
hash="$(nix-prefetch-url --unpack "$snapshotUrl")"
sriHash="$(nix --experimental-features nix-command hash to-sri "sha256:$hash")"

sed "s/hash = \".*\"/hash = \"$sriHash\"/" -i default.nix
