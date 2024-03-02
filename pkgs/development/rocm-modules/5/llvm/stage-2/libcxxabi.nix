{ stdenv
, callPackage
, rocmUpdateScript
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildDocs = false; # No documentation to build
  buildMan = false; # No man pages to build
  targetName = "libcxxabi";
  targetDir = "runtimes";

  targetRuntimes = [
    "libunwind"
    targetName
    "libcxx"
  ];

  extraCMakeFlags = [
    "-DLIBCXXABI_INCLUDE_TESTS=ON"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
    "-DLIBCXXABI_USE_COMPILER_RT=ON"

    # Workaround having to build combined
    "-DLIBUNWIND_INCLUDE_DOCS=OFF"
    "-DLIBUNWIND_INCLUDE_TESTS=OFF"
    "-DLIBUNWIND_USE_COMPILER_RT=ON"
    "-DLIBUNWIND_INSTALL_LIBRARY=OFF"
    "-DLIBUNWIND_INSTALL_HEADERS=OFF"
    "-DLIBCXX_INCLUDE_DOCS=OFF"
    "-DLIBCXX_INCLUDE_TESTS=OFF"
    "-DLIBCXX_USE_COMPILER_RT=ON"
    "-DLIBCXX_CXX_ABI=libcxxabi"
    "-DLIBCXX_INSTALL_LIBRARY=OFF"
    "-DLIBCXX_INSTALL_HEADERS=OFF"
  ];
}
