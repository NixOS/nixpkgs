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
      knownVulnerabilities = [
        "CVE-2026-48995"
        "CVE-2026-50014"
        "CVE-2026-50015"
        "CVE-2026-50016"
        "CVE-2026-50017"
        "CVE-2026-50573"
        "CVE-2026-55699"
      ];
    };
    # 10.34.1 made a breaking change that causes
    # ERR_PNPM_MISSING_TARBALL_INTEGRITY error for some packages.
    "10_34_0" = {
      version = "10.34.0";
      hash = "sha256-WOFDJYhx31FYm2UcBiBdq+xIdmpdu6PCWZm2m1C+WY4=";
      knownVulnerabilities = [
        "CVE-2026-55487"
        "CVE-2026-55698"
        "CVE-2026-55180"
        "CVE-2026-55697"
      ];
    };
    "10" = {
      version = "10.34.4";
      hash = "sha256-mM1XGNvYxLJokVZJO5WWzs9rZLGpjUoIfoITWhdbQOs=";
    };
    "11" = {
      version = "11.9.0";
      hash = "sha256-K1Z6pmAmI4B4rC4KM77D/r1g6WKYeqxpdFbzGAgZsoc=";
    };
  };

  callPnpm =
    variant:
    callPackage ./generic.nix {
      inherit (variant) version hash;
      knownVulnerabilities = variant.knownVulnerabilities or [ ];
      #FIXME: remove this hack in a future version.
      nodejs = null; # Passing null to detect out-of-tree overrides
    };

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
