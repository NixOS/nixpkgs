#!/usr/bin/env nix-shell
#!nix-shell -i nu -p common-updater-scripts

let tags = list-git-tags --url=https://github.com/openvswitch/ovs | lines | sort --natural | str replace v ''

let latest = $tags | last
let lts = $tags | find --regex "2\\.17.*" | last

let current_latest = nix eval --raw -f default.nix openvswitch.version | str trim
let current_lts = nix eval --raw -f default.nix openvswitch-lts.version | str trim

if $latest != $current_latest {
  update-source-version openvswitch $latest $"--file=(pwd)/pkgs/os-specific/linux/openvswitch/default.nix"
}

if $lts != $current_lts {
  update-source-version openvswitch-lts $lts $"--file=(pwd)/pkgs/os-specific/linux/openvswitch/lts.nix"
}

[
  {release: latest, before: $current_latest, after: $latest},
  {release: lts, before: $current_lts, after: $lts}
]
