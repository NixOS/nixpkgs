#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p nix-prefetch git gnused gnugrep nix curl
# shellcheck shell=bash
set -euo pipefail -x

nixpkgs="$(git rev-parse --show-toplevel)"
old=$(nix-instantiate --eval -A linuxPackages_zen.kernel.modDirVersion "$nixpkgs")
old="${old%\"}"
old="${old#\"}"
new=$(curl https://github.com/zen-kernel/zen-kernel/releases.atom | grep -m1 -o -E '[0-9.]+-zen[0-9]+')
if [[ "$new" == "$old" ]]; then
    echo "already up-to-date"
    exit 0
fi

path="$nixpkgs/pkgs/os-specific/linux/kernel/linux-zen.nix"

sed -i -e "s!modDirVersion = \".*\"!modDirVersion = \"${new}\"!" "$path"
checksum=$(nix-prefetch "(import ${nixpkgs} {}).linuxPackages_zen.kernel")
sed -i -e "s!sha256 = \".*\"!sha256 = \"${checksum}\"!" "$path"

git commit -m "linux_zen: ${old} -> ${new}" $path
