{ lib, callPackage }:
let
  inherit (lib) mapAttrs' nameValuePair;

  variants = {
    "8" = {
      version = "8.15.9";
      hash = "sha256-2qJ6C1QbxjUyP/lsLe2ZVGf/n+bWn/ZwIVWKqa2dzDY=";
    };
    "9" = {
      version = "9.12.1";
      hash = "sha256-kUUv36RiNK5EfUbVxPxOfgpwWPkElcS293+L7ruxVOM=";
    };
  };

  callPnpm = variant: callPackage ./generic.nix {inherit (variant) version hash;};

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
