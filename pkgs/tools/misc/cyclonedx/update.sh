#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix

$(nix-build '<nixpkgs>' -A cyclonedx.passthru.fetch-deps) ./deps.nix
