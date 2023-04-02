{ callPackage, openssl, python3, fetchpatch, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  npmPatches = callPackage ./npm-patches.nix { };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.20.0";
    sha256 = "sha256-4JkPmSI05ApR/hH5LDgWyTp34bCBFF0912LNECY0U0k=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      ./bypass-darwin-xcrun-node16.patch
    ] ++ npmPatches;
  }
