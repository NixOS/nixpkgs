{ callPackage, ... } @ args:

callPackage ./generic.nix args {
  # Note: Please use the recommended version for Chromium stabe, i.e. from
  # <nixpkgs>/pkgs/applications/networking/browsers/chromium/upstream-info.nix
  rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
  revNum = "2140"; # git describe $rev --match initial-commit | cut -d- -f3
  version = "2024-01-22";
  sha256 = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
}
