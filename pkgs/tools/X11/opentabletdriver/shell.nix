{ pkgs ? import ../../../../. {} }:

with pkgs;

mkShell {
  buildInputs = [
    common-updater-scripts
    curl
    dotnetCorePackages.sdk_5_0
    jq
  ];
}
