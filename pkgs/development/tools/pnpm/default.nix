{
  lib,
  callPackage,
}:
let
  inherit (lib) mapAttrs' nameValuePair;

  variants = {
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
        "CVE-2026-59194"
        "CVE-2026-59195"
        "CVE-2026-59196"
        "CVE-2026-82392"
        "CVE-2026-82393"
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
        "CVE-2026-59194"
        "CVE-2026-59195"
        "CVE-2026-59196"
        "CVE-2026-82392"
        "CVE-2026-82393"
      ];
    };
    "10" = {
      version = "10.34.7";
      hash = "sha256-xyn2U44AXSNIiZEEZv0cTESv+wso6obZP8+IqhrvppQ=";
    };
    "11" = {
      version = "11.27.0";
      hash = "sha256-QKMlFaJVB/jyJt+74lOA4vBTlEwuzGTAwcuYtBy7ke8=";
    };
    "12" = {
      version = "12.18.0";
      srcHash = "sha256-4mN9hcQVZcOU8A7pU4FTRR+m6U1NJHKSs/AY+drZD3w=";
      cargoHash = "sha256-zz3ypFc8XRkxeZf7x+cMXuMMdm9GGgFeilDE/4mh5D0=";
      patches = [
        # macOS bash 3.2 answers `command -p -v` from PATH, so bin shims run
        # `command -p sed`, which the darwin sandbox denies.
        # https://github.com/pnpm/pnpm/issues/17750
        ./12-shim-darwin-sandbox.patch
      ];
    };
  };

  callPnpmNode =
    variant:
    callPackage ./generic.nix (
      variant
      // {
        #FIXME: remove this hack in a future version.
        nodejs = null; # Passing null to detect out-of-tree overrides
      }
    );

  callPnpmRust = callPackage ./generic-rust.nix;

  callPnpm = variant: if variant ? cargoHash then callPnpmRust variant else callPnpmNode variant;

  mkPnpm = versionSuffix: variant: nameValuePair "pnpm_${versionSuffix}" (callPnpm variant);
in
mapAttrs' mkPnpm variants
