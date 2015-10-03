## Configuration:
# Control you default wine config in nixpkgs-config:
# wine = {
#   release = "stable"; # "stable", "unstable", "staging"
#   build = "wineWow"; # "wine32", "wine64", "wineWow"
# };
# Make additional configurations on demand:
# wine.override { wineBuild = "wine32"; wineRelease = "staging"; };
{ lib, pkgs, system, callPackage, wineUnstable,
  wineRelease ? "stable",
  wineBuild ? (if system == "x86_64-linux" then "wineWow" else "wine32"),
  libtxc_dxtn_Name ? "libtxc_dxtn_s2tc" }:

if wineRelease == "staging" then
  callPackage ./staging.nix {
    inherit libtxc_dxtn_Name;
    wine = wineUnstable;
  }
else
  lib.getAttr wineBuild (callPackage ./packages.nix {
    inherit wineRelease;
  })
