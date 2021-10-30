{ pkgs ? import ../../../../. { } }:

with pkgs;

mkShell {
  packages = [
    common-updater-scripts
    nuget-to-nix
    curl
    dotnetCorePackages.sdk_5_0
    jq
  ];
}
