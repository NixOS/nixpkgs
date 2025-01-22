#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../ -i bash -p guile curl

curl -sSf https://archive.akkuscm.org/archive/Akku-index.scm | guile parse-akku.scm deps > deps.toml
