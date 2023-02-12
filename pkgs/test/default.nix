{ pkgs, callPackage }:

with pkgs;

{
  cc-wrapper = callPackage ./cc-wrapper { };
  cc-wrapper-gcc = callPackage ./cc-wrapper { stdenv = gccStdenv; };
  cc-wrapper-gcc7 = callPackage ./cc-wrapper { stdenv = gcc7Stdenv; };
  cc-wrapper-gcc8 = callPackage ./cc-wrapper { stdenv = gcc8Stdenv; };
  cc-wrapper-gcc9 = callPackage ./cc-wrapper { stdenv = gcc9Stdenv; };
  cc-wrapper-clang = callPackage ./cc-wrapper { stdenv = llvmPackages.stdenv; };
  cc-wrapper-libcxx = callPackage ./cc-wrapper { stdenv = llvmPackages.libcxxStdenv; };
  cc-wrapper-clang-5 = callPackage ./cc-wrapper { stdenv = llvmPackages_5.stdenv; };
  cc-wrapper-libcxx-5 = callPackage ./cc-wrapper { stdenv = llvmPackages_5.libcxxStdenv; };
  cc-wrapper-clang-6 = callPackage ./cc-wrapper { stdenv = llvmPackages_6.stdenv; };
  cc-wrapper-libcxx-6 = callPackage ./cc-wrapper { stdenv = llvmPackages_6.libcxxStdenv; };
  cc-wrapper-clang-7 = callPackage ./cc-wrapper { stdenv = llvmPackages_7.stdenv; };
  cc-wrapper-libcxx-7 = callPackage ./cc-wrapper { stdenv = llvmPackages_7.libcxxStdenv; };
  cc-wrapper-clang-8 = callPackage ./cc-wrapper { stdenv = llvmPackages_8.stdenv; };
  cc-wrapper-libcxx-8 = callPackage ./cc-wrapper { stdenv = llvmPackages_8.libcxxStdenv; };
  cc-wrapper-clang-9 = callPackage ./cc-wrapper { stdenv = llvmPackages_9.stdenv; };
  cc-wrapper-libcxx-9 = callPackage ./cc-wrapper { stdenv = llvmPackages_9.libcxxStdenv; };
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
