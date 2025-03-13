{
  lib,
  callPackage,
}:

let
  inherit (lib) mapAttrs' nameValuePair;

  variants = {
    "8" = {
      version = "8.15.9";
      hash = "sha256-2qJ6C1QbxjUyP/lsLe2ZVGf/n+bWn/ZwIVWKqa2dzDY=";
    };
    "9" = {
      version = "9.15.7";
      hash = "sha256-HBjZi6W/BzT8fij2yPG0OxvNhmd33s3igdFIWTkGA/w=";
    };
    "10" = {
      version = "10.6.2";
      hash = "sha256-IAcqH27dF2RuqSNL8yxC1WPa03spc+l6Ld5cF3dKgk0=";
    };
  };

  callPnpm = variant: callPackage ./generic.nix { inherit (variant) version hash; };

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
