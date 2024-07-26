#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts

def main [--lts: bool = false, --regex: string] {
  let tags = list-git-tags --url=https://github.com/openvswitch/ovs | lines | sort --natural | str replace v ''

  let latest_tag = if $regex == null { $tags } else { $tags | find --regex $regex } | last
  let current_version = nix eval --raw -f default.nix $"openvswitch(if $lts {"-lts"}).version" | str trim

  if $latest_tag != $current_version {
    if $lts {
      update-source-version openvswitch-lts $latest_tag $"--file=(pwd)/pkgs/os-specific/linux/openvswitch/lts.nix"
    } else {
      update-source-version openvswitch $latest_tag $"--file=(pwd)/pkgs/os-specific/linux/openvswitch/default.nix"
    }
  }

  {"lts?": $lts, before: $current_version, after: $latest_tag}
}
