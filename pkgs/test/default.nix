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
  cc-wrapper-clang-39 = callPackage ./cc-wrapper { stdenv = llvmPackages_39.stdenv; };
  cc-wrapper-libcxx-39 = callPackage ./cc-wrapper { stdenv = llvmPackages_39.libcxxStdenv; };
  cc-wrapper-clang-4 = callPackage ./cc-wrapper { stdenv = llvmPackages_4.stdenv; };
  cc-wrapper-libcxx-4 = callPackage ./cc-wrapper { stdenv = llvmPackages_4.libcxxStdenv; };
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

  haskell-shellFor = callPackage ./haskell-shellFor { };

  cc-multilib-gcc = callPackage ./cc-wrapper/multilib.nix { stdenv = gccMultiStdenv; };
  cc-multilib-clang = callPackage ./cc-wrapper/multilib.nix { stdenv = clangMultiStdenv; };

  kernel-config = callPackage ./kernel.nix {};

  ld-library-path = callPackage ./ld-library-path {};

  macOSSierraShared = callPackage ./macos-sierra-shared {};

  cross = callPackage ./cross {};

  nixos-functions = callPackage ./nixos-functions {};

  patch-shebangs = callPackage ./patch-shebangs {};

  writers = callPackage ../build-support/writers/test.nix {};
}
