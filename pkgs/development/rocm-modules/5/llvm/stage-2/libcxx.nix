{ stdenv
, callPackage
, rocmUpdateScript
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildMan = false; # No man pages to build
  targetName = "libcxx";
  targetDir = "runtimes";

  targetRuntimes = [
    "libunwind"
    "libcxxabi"
    targetName
  ];

  extraCMakeFlags = [
    "-DLIBCXX_INCLUDE_DOCS=ON"
    "-DLIBCXX_INCLUDE_TESTS=ON"
    "-DLIBCXX_USE_COMPILER_RT=ON"
    "-DLIBCXX_CXX_ABI=libcxxabi"

    # Workaround having to build combined
    "-DLIBUNWIND_INCLUDE_DOCS=OFF"
    "-DLIBUNWIND_INCLUDE_TESTS=OFF"
    "-DLIBUNWIND_USE_COMPILER_RT=ON"
    "-DLIBUNWIND_INSTALL_LIBRARY=OFF"
    "-DLIBUNWIND_INSTALL_HEADERS=OFF"
    "-DLIBCXXABI_INCLUDE_TESTS=OFF"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
    "-DLIBCXXABI_USE_COMPILER_RT=ON"
    "-DLIBCXXABI_INSTALL_LIBRARY=OFF"
    "-DLIBCXXABI_INSTALL_HEADERS=OFF"
  ];

  # Most of these can't find `bash` or `mkdir`, might just be hard-coded paths, or PATH is altered
  extraPostPatch = ''
    chmod +w -R ../libcxx/test/{libcxx,std}
    cat ${./1000-libcxx-failing-tests.list} | xargs -d \\n rm
  '';
}
