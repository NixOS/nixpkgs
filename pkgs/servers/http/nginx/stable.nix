{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.14.1";
  sha256 = "19542jxcjf4dvrqvgb5vr36mhbzcjrxc3v0xh451rm60610rf2dz";
})
