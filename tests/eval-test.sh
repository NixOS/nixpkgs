#!/bin/sh

set -e

cd "$(dirname "$0")/.."

for profile in $(find . -name default.nix); do
  echo evaluating $profile >&2

  nix-build '<nixpkgs/nixos>' \
    -I nixos-config=tests/eval-test.nix \
    -I nixos-hardware-profile=$profile \
    -A system \
    --dry-run
done
