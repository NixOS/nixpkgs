#!/usr/bin/env bash

upload() {
  ~/.cargo/bin/xzar --server planai upload --pin "$1" --desc $(readlink -f result) --leave-after-abandon 1m result
}

build() {
  nix-build -A "$1"
}

build openclaw
upload openclaw
build ollama
upload ollama
