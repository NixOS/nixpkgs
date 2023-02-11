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
    version = "16.19.0";
    sha256 = "01k72p0hp4lhlpz1syd9cbkm2gpfww0hn10xdpmzd4i3x8dfq7sg";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      ./bypass-darwin-xcrun-node16.patch
    ] ++ npmPatches;
  }
