{ callPackage, lib, overrideCC, pkgs, buildPackages, openssl, python3, enableNpm ? true }:

let
  # Clang 16+ cannot build Node v14 due to -Wenum-constexpr-conversion errors.
  # Use an older version of clang with the current libc++ for compatibility (e.g., with icu).
  ensureCompatibleCC = packages:
    if packages.stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion packages.stdenv.cc.cc) "16"
      then overrideCC packages.llvmPackages_15.stdenv (packages.llvmPackages_15.stdenv.cc.override {
        inherit (packages.llvmPackages) libcxx;
        extraPackages = [ packages.llvmPackages.libcxxabi ];
      })
      else packages.stdenv;

  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    stdenv = ensureCompatibleCC pkgs;
    buildPackages = buildPackages // { stdenv = ensureCompatibleCC buildPackages; };
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.21.3";
    sha256 = "sha256-RY7AkuYK1wDdzwectj1DXBXaTHuz0/mbmo5YqZ5UB14=";
    patches = lib.optional pkgs.stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
