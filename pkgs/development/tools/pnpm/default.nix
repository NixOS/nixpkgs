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
      version = "9.15.3";
      hash = "sha256-wdpDcnzLwe1Cr/T9a9tLHpHmWoGObv/1skD78HC6Tq8=";
    };
    "10" = {
      version = "10.0.0";
      hash = "sha256-Q6v25yD7e8U8WRsIYmBcfTI9Cp0t0zvKwHsGLhPPSUg=";
    };
  };

  callPnpm = variant: callPackage ./generic.nix { inherit (variant) version hash; };

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
