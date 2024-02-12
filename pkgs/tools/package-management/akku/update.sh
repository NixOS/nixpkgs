#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../ -i oil -p oil akku python3

# akku update

cd $(mktemp -d)

akku list 2> /dev/null | python3 $_this_dir/parse_akku.py akku-list | json read
for l in (_reply) {
    var modname, synopsis = l
    akku show $modname 2> /dev/null | python3 $_this_dir/parse_akku.py akku-show $modname $synopsis
} > $_this_dir/deps.toml
