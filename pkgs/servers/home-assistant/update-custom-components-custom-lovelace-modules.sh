#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update

cd "${BASH_SOURCE[0]%/*}/../../.." || exit 5

for package_set in custom-components custom-lovelace-modules themes; do
  for package in pkgs/servers/home-assistant/"$package_set"/*; do
    while (( $(jobs -rp | wc -l) >= 5 )); do wait -n; done
    nix-update --build --commit "home-assistant-$package_set.${package##*/}" &
  done
done
wait
