#!/usr/bin/env bash
nix-shell "$(git rev-parse --show-toplevel)" -A godot3-mono.make-deps --run 'eval "$makeDeps"'
