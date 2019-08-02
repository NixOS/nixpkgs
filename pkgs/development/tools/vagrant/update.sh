#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts

set -eu -o pipefail

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; vagrant.version or (builtins.parseDrvName vagrant.name).version" | tr -d '"')"
latestTag="$(git ls-remote --tags --sort="v:refname" git://github.com/hashicorp/vagrant.git | grep -v '\{\}' | grep -v '\-rc' | tail -1 | sed 's|^.*/v\(.*\)|\1|')"

if [ ! "${oldVersion}" = "${latestTag}" ]; then

    update-source-version vagrant "${latestTag}"

    nixpkgs="$(git rev-parse --show-toplevel)"
    default_nix="$nixpkgs/pkgs/development/tools/vagrant/default.nix"
    tmp_dir=$(mktemp -d -t nixpkgs-vagrant-XXXXXXX)

    git clone https://github.com/hashicorp/vagrant.git "$tmp_dir"
    cd "$tmp_dir"
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

    nix-shell -p bundler --run 'bundle lock'
    nix-shell -p bundix --run 'bundix'

    cd "$nixpkgs/pkgs/development/tools/vagrant/"
    cp "$tmp_dir/gemset.nix" .

    rm -rf "$tmp_dir"

    echo "vagrant has been updated to $latestTag."

else
    echo "vagrant is already up-to-date"
fi
