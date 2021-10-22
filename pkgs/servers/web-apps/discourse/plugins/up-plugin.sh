#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl ruby.devEnv git sqlite libpcap postgresql libxml2 libxslt pkg-config bundix gnumake
# src https://nixos.wiki/wiki/Packaging/Ruby

# This script should be ran afte rupdating a plugin that has a gemset.nix
# Usage: ./up-plugin.sh <plugin-id>
# NOTE: Script must be ran directly as ./up-plugin, otherwise the nix-shell won't work

set -exuo pipefail

PLUGIN="$1"
SELF="$(dirname "$(readlink -f "$0")")"

PL_DIR="$SELF/$PLUGIN"
TOP="$SELF/../../../../.."
TMP=$(mktemp -d)

pushd "$TMP"

if cat "$PL_DIR/default.nix" | grep gemdir >/dev/null; then
  nix-build -A discourse.plugins.$PLUGIN.src "$TOP"
  if [ -e result/Gemfile ]; then
    cp result/Gemfile Gemfile
    if [ -e result/Gemfile.lock ]; then
      cp result/Gemfile.lock Gemfile.lock
    fi
  else
    echo '# frozen_string_literal: true

source "https://rubygems.org"' > Gemfile
    cat result/plugin.rb | grep "^gem" >> Gemfile
  fi
  if [ ! -e Gemfile.lock ]; then
    bundle install
  fi
  bundix
  cp Gemfile Gemfile.lock gemset.nix "$PL_DIR"
fi

