#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash bundix bundler
# shellcheck shell=bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

rm -f Gemfile.lock Gemfile.lock
bundler lock
BUNDLE_GEMFILE=Gemfile bundler lock --lockfile=Gemfile.lock
bundix --gemfile=Gemfile --lockfile=Gemfile.lock --gemset=gemset.nix
