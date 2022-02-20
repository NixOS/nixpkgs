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

  haskell = callPackage ./haskell { };

  cc-multilib-gcc = callPackage ./cc-wrapper/multilib.nix { stdenv = gccMultiStdenv; };
  cc-multilib-clang = callPackage ./cc-wrapper/multilib.nix { stdenv = clangMultiStdenv; };

  fetchpatch = callPackages ../build-support/fetchpatch/tests.nix { };
  fetchgit = callPackages ../build-support/fetchgit/tests.nix { };
  fetchFirefoxAddon = callPackages ../build-support/fetchfirefoxaddon/tests.nix { };

  install-shell-files = callPackage ./install-shell-files {};

  kernel-config = callPackage ./kernel.nix {};

  ld-library-path = callPackage ./ld-library-path {};

  macOSSierraShared = callPackage ./macos-sierra-shared {};

  cross = callPackage ./cross {};

  php = recurseIntoAttrs (callPackages ./php {});

  rustCustomSysroot = callPackage ./rust-sysroot {};
  buildRustCrate = callPackage ../build-support/rust/build-rust-crate/test { };
  importCargoLock = callPackage ../build-support/rust/test/import-cargo-lock { };

  vim = callPackage ./vim {};

  nixos-functions = callPackage ./nixos-functions {};

  patch-shebangs = callPackage ./patch-shebangs {};

  texlive = callPackage ./texlive {};

  cuda = callPackage ./cuda { };

  trivial-builders = recurseIntoAttrs {
    writeStringReferencesToFile = callPackage ../build-support/trivial-builders/test/writeStringReferencesToFile.nix {};
    references = callPackage ../build-support/trivial-builders/test/references.nix {};
    overriding = callPackage ../build-support/trivial-builders/test-overriding.nix {};
    concat = callPackage ../build-support/trivial-builders/test/concat-test.nix {};
  };

  writers = callPackage ../build-support/writers/test.nix {};

  dhall = callPackage ./dhall { };

  makeWrapper = callPackage ./make-wrapper {};
}
