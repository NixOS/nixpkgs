#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell xwin
#!nix-shell -I nixpkgs=./.

use std/log
use std/dirs

const MANIFEST_URL = "https://aka.ms/vs/17/release/channel"

const PATH = "pkgs/os-specific/windows/msvcSdk"

def replace_hash [ p: path old: string new: string ] {
  open $p
  | str replace $old $new
  | save -f $p
}

def main [] {
  # Ensure the version is actually new
  let current_version = nix eval -f "" windows.sdk.version --json | from json

  let new_manifest = http get $MANIFEST_URL | decode | from json
  let new_version = $new_manifest.info.buildVersion

  if $current_version == $new_version {
      log info "Current Windows SDK manifest matches the newest version, exiting..."
      exit 0
  } else {
    log info $"Previous version ($current_version)\nNew version ($new_version)"
  }

  $new_manifest | to json | append "\n" | str join | save -f ($PATH | path join manifest.json)

  # TODO: Add arm once it isn't broken
  let hashes = ["x86_64", "x86", "aarch64"] | par-each {
    |arch|
    let dir = mktemp -d

    xwin --accept-license --cache-dir $dir --manifest $"($PATH | path join manifest.json)" --arch $arch splat --preserve-ms-arch-notation

    let hash = nix hash path ($dir | path join splat)

    {arch: $arch, hash: $hash}
  } | transpose -r -d

  log info $"New hashes:\n ($hashes)"

  $hashes | to json | append "\n" | str join | save -f ($PATH | path join hashes.json)
}
