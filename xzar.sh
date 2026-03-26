#!/usr/bin/env bash

set -euxo pipefail

upload() {
  ~/.cargo/bin/xzar --server planai upload --pin "$1" --desc $(readlink -f result) --leave-after-abandon 1m result
}

build() {
  NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1 nix-build -A "$1"
}

build openclaw
upload openclaw
for flavour in cpu rocm cuda vulkan; do
  build "ollama-$flavour"
  upload "ollama/$flavour"
done
build nix
upload nix
