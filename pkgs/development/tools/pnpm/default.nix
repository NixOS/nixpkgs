{ lib, callPackage }:
let
  inherit (lib) mapAttrs' nameValuePair;

  variants = {
    "8" = {
      version = "8.15.8";
      hash = "sha256-aR/hdu6pqKgN8g5JdvPftEoEhBzriFY4/iomF0+B5l4=";
    };
    "9" = {
      version = "9.1.1";
      hash = "sha256-lVHoA9y3oYOf31QWFTqEQGDHvOATIYzoI0EFMlBKwQs=";
    };
  };

  callPnpm = variant: callPackage ./generic.nix {inherit (variant) version hash;};

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
