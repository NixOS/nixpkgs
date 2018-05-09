{callPackage, gccMultiStdenv, clangMultiStdenv
, gccStdenv, gcc7Stdenv, gcc8Stdenv
, llvmPackages, llvmPackages_39, llvmPackages_4, llvmPackages_5, llvmPackages_6 }:

{
  cc-wrapper = callPackage ../test/cc-wrapper { };
  cc-wrapper-gcc = callPackage ../test/cc-wrapper { stdenv = gccStdenv; };
  cc-wrapper-gcc7 = callPackage ../test/cc-wrapper { stdenv = gcc7Stdenv; };
  cc-wrapper-gcc8 = callPackage ../test/cc-wrapper { stdenv = gcc8Stdenv; };
  cc-wrapper-clang = callPackage ../test/cc-wrapper { stdenv = llvmPackages.stdenv; };
  cc-wrapper-libcxx = callPackage ../test/cc-wrapper { stdenv = llvmPackages.libcxxStdenv; };
  cc-wrapper-clang-39 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_39.stdenv; };
  cc-wrapper-libcxx-39 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_39.libcxxStdenv; };
  cc-wrapper-clang-4 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_4.stdenv; };
  cc-wrapper-libcxx-4 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_4.libcxxStdenv; };
  cc-wrapper-clang-5 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_5.stdenv; };
  cc-wrapper-libcxx-5 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_5.libcxxStdenv; };
  cc-wrapper-clang-6 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_6.stdenv; };
  cc-wrapper-libcxx-6 = callPackage ../test/cc-wrapper { stdenv = llvmPackages_6.libcxxStdenv; };
  stdenv-inputs = callPackage ../test/stdenv-inputs { };

  cc-multilib-gcc = callPackage ../test/cc-wrapper/multilib.nix { stdenv = gccMultiStdenv; };
  cc-multilib-clang = callPackage ../test/cc-wrapper/multilib.nix { stdenv = clangMultiStdenv; };

  macOSSierraShared = callPackage ../test/macos-sierra-shared {};
}
