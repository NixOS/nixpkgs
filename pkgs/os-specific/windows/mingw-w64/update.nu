#!/usr/bin/env nix-shell
#! nix-shell -i nu -p nushell nix

use std/log

def replace [ p: path old: string new: string ] {
  open $p
  | str replace $old $new
  | save -f $p
}

def eval [ attr: string ] {
  with-env {
    NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM: 1
  } {
    nix eval -f ./. $attr --json
  }
  | from json
}

def main [] {
  # List of all the link in the RSS feed for
  # https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/
  let links = http get https://sourceforge.net/projects/mingw-w64/rss?path=/mingw-w64/mingw-w64-release/
  | from xml
  | get content.content.0
  | where tag == item
  | get content
  | flatten
  | where tag == title
  | get content
  | flatten
  | get content

  # Select only files ending in "tar.bz2", then select the largest value
  # We only consider values with at least two digits cause they are at
  # 13.0 and sorting strings doesn't work well if they aren't the same length
  let newest = $links
    | where { ($in | str ends-with "tar.bz2") and ($in =~ v[0-9][0-9]\.) }
    | sort -r
    | get 0

  # Extract the newest version out of the URL
  let new_version = $newest
    | split column /
    | get column4.0
    | split column -
    | get column3.0
    | str replace .tar.bz2 ""
    | str trim -c v

  # Get the current version in the drv
  let current_version = eval "windows.mingw_w64_headers.version"

  if $new_version == $current_version {
    log info "Current mingw-w64 version matches the latest, exiting..."
    return
  } else {
    log info $"Current version is ($current_version)\nLatest version is ($new_version)"
  }

  # Get the current hash
  let current_hash = eval "windows.mingw_w64_headers.src.outputHash"

  # Set to the new version
  replace ./pkgs/os-specific/windows/mingw-w64/headers.nix $current_version $new_version

  # The nix derivation creates the URL from the version, so just grab that.
  let new_url = eval "windows.mingw_w64_headers.src.url"

  # Prefetch to get the new hash
  let new_hash = nix-prefetch-url --type sha256 $new_url
  | nix hash to-sri --type sha256 $in

  # Set the hash
  replace ./pkgs/os-specific/windows/mingw-w64/headers.nix $current_hash $new_hash
}
