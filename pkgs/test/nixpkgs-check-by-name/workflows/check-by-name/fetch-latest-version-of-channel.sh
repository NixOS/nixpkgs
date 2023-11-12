#!/usr/bin/env bash
echo "Fetching latest version of channel $channel"
# This is probably the easiest way to get Nix to output the path to a downloaded channel!
nixpkgs=$(nix-instantiate --find-file nixpkgs -I nixpkgs=channel:"$channel")
# This file only exists in channels
toolingBinariesSha=$(<"$nixpkgs"/.git-revision)
echo "Channel $channel is at revision $toolingBinariesSha"
echo "nixpkgs=$nixpkgs" >> "$GITHUB_ENV"
echo "toolingBinariesSha=$toolingbinariesSha" >> "$GITHUB_ENV"
