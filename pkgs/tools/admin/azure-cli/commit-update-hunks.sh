#!/usr/bin/env bash

# Just a tiny imperfect helper script to commit generated updates.
#
# First, ensure that that `git add -p extensions-generated.nix` only
# returns a series of clean update hunks, where each hunk updates a
# single package version. All additions/removals must be committed
# by hand.
# The script will then commit the remaining hunks with fitting commit messages.

while true; do
  echo -e "y\nq" | git add -p extensions-generated.nix || break
  pname=$(git diff --no-ext-diff --cached | grep "pname =" | cut -d'"' -f2 | head -n1) || break
  versions=$(git diff --no-ext-diff --cached | grep "version =" | cut -d'"' -f2) || break
  oldver=$(echo "$versions" | head -n1) || break
  newver=$(echo "$versions" | tail -n1) || break
  commitmsg="azure-cli-extensions.${pname}: ${oldver} -> ${newver}"
  git commit -m "$commitmsg"
done
