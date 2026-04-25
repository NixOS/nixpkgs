#!/usr/bin/env bash

set -euxo pipefail

upload() {
  ~/.cargo/bin/xzar --server planai upload --pin "$1/$(nix-instantiate --eval -E 'builtins.currentSystem' | tr -d '"')" --desc $(readlink -f result) --leave-after-abandon 1m result
}

build() {
  NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1 nix-build -A "$1"
}

build openclaw
upload openclaw
flavours="cpu"
if [ "$(uname)" != "Darwin" ]; then
  flavours="cpu rocm cuda vulkan"
fi
for flavour in $flavours; do
  build "ollama-$flavour"
  upload "ollama/$flavour"
done
build nix
upload nix
build mcporter
upload mcporter
if [ "$(uname)" != "Darwin" ]; then
  build cudatoolkit
  upload cudatoolkit
  build rocmPackages.rocm-smi
  upload rocmPackages.rocm-smi
fi
build lmstudio
upload lmstudio
build unsloth
upload unsloth
