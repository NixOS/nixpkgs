{ pkgs ? import ../../../../. { } }:

with pkgs;

mkShell {
  packages = [
    common-updater-scripts
    curl
    dotnetCorePackages.sdk_5_0
    jq
  ];
}
