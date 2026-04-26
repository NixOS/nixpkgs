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
      version = "9.15.9";
      hash = "sha256-z4anrXZEBjldQoam0J1zBxFyCsxtk+nc6ax6xNxKKKc=";
    };
    # 10.29.3 made a breaking change: https://github.com/pnpm/pnpm/issues/10601.
    # Pnpm packages that depend on electron builder must be upgraded to 26.8.2 or newer
    # otherwise a runtime error will occur when launching the application.
    "10_29_2" = {
      version = "10.29.2";
      hash = "sha256-hAL2daH0zJ1PJ7v6s1wtSi4dfrATHfA9rQlhnoZnTQw=";
    };
    "10" = {
      version = "10.33.2";
      hash = "sha256-envPE9f2zrOUbAOXg3PZm+n94cr8MAC9/tTE95EWdhA=";
    };
  };

  callPnpm = variant: callPackage ./generic.nix { inherit (variant) version hash; };

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
