#!/usr/bin/env bash

set -euo pipefail

nix-shell -p rustc cargo gcc pkg-config openssl --run "cargo install --git https://github.com/mkg20001/xzar xzar-client --bin xzar"
nix profile install nixpkgs#pixz
~/.cargo/bin/xzar config add-server planai https://xzar.plan.ai "$XZAR_TOKEN"

if [ "$(uname)" != "Darwin" ]; then
  cp -L /etc/nix/nix.conf /etc/nix/nix.conf.
  rm /etc/nix/nix.conf
  mv /etc/nix/nix.conf. /etc/nix/nix.conf

  echo "substituters = https://cache.nixos.org/ https://xzar.plan.ai" | tee -a /etc/nix/nix.conf
  echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= xzar.plan.ai:KUE66pjr6UX5HHCn9kedN1DJ2J5nSlBrKmE7tUjXewE=" | tee -a /etc/nix/nix.conf

  systemctl restart nix-daemon
fi
