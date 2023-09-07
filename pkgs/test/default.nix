{ pkgs, callPackage }:

with pkgs;

{
  cc-wrapper = with builtins; let
    pkgNames = (attrNames pkgs);
    llvmTests = let
      pkgSets = lib.pipe pkgNames [
        (filter (lib.hasPrefix "llvmPackages"))
        (filter (n: n != "llvmPackages_rocm"))
        (filter (n: n != "llvmPackages_latest"))
        (filter (n: n != "llvmPackages_git"))
      ];
      tests = lib.genAttrs pkgSets (name: recurseIntoAttrs {
        clang = callPackage ./cc-wrapper { stdenv = pkgs.${name}.stdenv; };
        libcxx = callPackage ./cc-wrapper { stdenv = pkgs.${name}.libcxxStdenv; };
      });
    in
      recurseIntoAttrs tests;
    gccTests = let
      pkgSets = lib.pipe (attrNames pkgs) ([
        (filter (lib.hasPrefix "gcc"))
        (filter (lib.hasSuffix "Stdenv"))
        (filter (n: n != "gccCrossLibcStdenv"))
      ] ++ lib.optionals (!(
        (stdenv.buildPlatform.isLinux && stdenv.buildPlatform.isx86_64) &&
        (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64)
      )) [
        (filter (n: !lib.hasSuffix "MultiStdenv" n))
      ]);
    in lib.genAttrs pkgSets (name: callPackage ./cc-wrapper { stdenv = pkgs.${name}; });
  in recurseIntoAttrs {
    default = callPackage ./cc-wrapper { };
  } // llvmTests // gccTests;

  stdenv-inputs = callPackage ./stdenv-inputs { };
  stdenv = callPackage ./stdenv { };

  hardeningFlags = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix {});
  hardeningFlags-gcc = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix {
    stdenv = gccStdenv;
  });
  hardeningFlags-clang = recurseIntoAttrs (callPackage ./cc-wrapper/hardening.nix {
    stdenv = llvmPackages.stdenv;
  });

  config = callPackage ./config.nix { };

  haskell = callPackage ./haskell { };

  hooks = callPackage ./hooks { };

  cc-multilib-gcc = callPackage ./cc-wrapper/multilib.nix { stdenv = gccMultiStdenv; };
  cc-multilib-clang = callPackage ./cc-wrapper/multilib.nix { stdenv = clangMultiStdenv; };

  fetchurl = callPackages ../build-support/fetchurl/tests.nix { };
  fetchpatch = callPackages ../build-support/fetchpatch/tests.nix { };
  fetchpatch2 = callPackages ../build-support/fetchpatch/tests.nix { fetchpatch = fetchpatch2; };
  fetchDebianPatch = callPackages ../build-support/fetchdebianpatch/tests.nix { };
  fetchzip = callPackages ../build-support/fetchzip/tests.nix { };
  fetchgit = callPackages ../build-support/fetchgit/tests.nix { };
  fetchFirefoxAddon = callPackages ../build-support/fetchfirefoxaddon/tests.nix { };

  install-shell-files = callPackage ./install-shell-files {};

  kernel-config = callPackage ./kernel.nix {};

  ld-library-path = callPackage ./ld-library-path {};

  macOSSierraShared = callPackage ./macos-sierra-shared {};

  cross = callPackage ./cross {};

  php = recurseIntoAttrs (callPackages ./php {});

  pkg-config = recurseIntoAttrs (callPackage ../top-level/pkg-config/tests.nix { });

  buildRustCrate = callPackage ../build-support/rust/build-rust-crate/test { };
  importCargoLock = callPackage ../build-support/rust/test/import-cargo-lock { };

  vim = callPackage ./vim {};

  nixos-functions = callPackage ./nixos-functions {};

  overriding = callPackage ./overriding.nix { };

  texlive = callPackage ./texlive {};

  cuda = callPackage ./cuda { };

  trivial-builders = callPackage ../build-support/trivial-builders/test/default.nix {};

  writers = callPackage ../build-support/writers/test.nix {};

  testers = callPackage ../build-support/testers/test/default.nix {};

  dhall = callPackage ./dhall { };

  cue-validation = callPackage ./cue {};

  coq = callPackage ./coq {};

  dotnet = recurseIntoAttrs (callPackages ./dotnet { });

  makeHardcodeGsettingsPatch = callPackage ./make-hardcode-gsettings-patch { };

  makeWrapper = callPackage ./make-wrapper { };
  makeBinaryWrapper = callPackage ./make-binary-wrapper {
    makeBinaryWrapper = pkgs.makeBinaryWrapper.override {
      # Enable sanitizers in the tests only, to avoid the performance cost in regular usage.
      # The sanitizers cause errors on aarch64-darwin, see https://github.com/NixOS/nixpkgs/pull/150079#issuecomment-994132734
      sanitizers = pkgs.lib.optionals (! (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64))
        [ "undefined" "address" ];
    };
  };

  pkgs-lib = recurseIntoAttrs (import ../pkgs-lib/tests { inherit pkgs; });

  nixpkgs-check-by-name = callPackage ./nixpkgs-check-by-name { };
}
