## Configuration:
# Control you default wine config in nixpkgs-config:
# wine = {
#   release = "stable"; # "stable", "unstable"
#   build = "wineWow"; # "wine32", "wine64", "wineWow"
# };
# Make additional configurations on demand:
# wine.overrideConfig { build = "wine32"; };
{ lib, system, callPackage,
  wineRelease ? "stable",
  wineBuild ? (if system == "x86_64-linux" then "wineWow" else "wine32") }:

lib.getAttr wineBuild (callPackage ./packages.nix {
  inherit wineRelease;
})
