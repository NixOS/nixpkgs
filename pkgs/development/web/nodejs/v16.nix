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
    # If you do upgrade here, please update in pkgs/top-level/release.nix
    # the permitted insecure version to ensure it gets cached for our users
    # and backport this to stable release (23.05).
    version = "16.20.2";
    sha256 = "sha256-V28aA8RV5JGo0TK1h+trO4RlH8iXS7NjhDPdRNIsj0k=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      ./bypass-darwin-xcrun-node16.patch
      ./node-npm-build-npm-package-logic-node16.patch
    ] ++ npmPatches;
  }
