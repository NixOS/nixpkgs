{
  lib,
  stdenv,
  callPackage,
  rocmUpdateScript,
  llvm,
  glibc,
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildDocs = false; # No documentation to build
  buildMan = false; # No man pages to build
  targetName = "compiler-rt";
  targetDir = "runtimes";

  targetRuntimes = [
    "libunwind"
    "libcxxabi"
    "libcxx"
    targetName
  ];

  extraCMakeFlags = [
    "-DCOMPILER_RT_INCLUDE_TESTS=ON"
    "-DCOMPILER_RT_USE_LLVM_UNWINDER=ON"
    "-DCOMPILER_RT_CXX_LIBRARY=libcxx"
    "-DCOMPILER_RT_CAN_EXECUTE_TESTS=OFF" # We can't run most of these

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
    "-DLIBCXX_INCLUDE_DOCS=OFF"
    "-DLIBCXX_INCLUDE_TESTS=OFF"
    "-DLIBCXX_USE_COMPILER_RT=ON"
    "-DLIBCXX_CXX_ABI=libcxxabi"
    "-DLIBCXX_INSTALL_LIBRARY=OFF"
    "-DLIBCXX_INSTALL_HEADERS=OFF"
  ];

  extraPostPatch = ''
    # `No such file or directory: 'ldd'`
    substituteInPlace ../compiler-rt/test/lit.common.cfg.py \
      --replace "'ldd'," "'${glibc.bin}/bin/ldd',"

    # We can run these
    substituteInPlace ../compiler-rt/test/CMakeLists.txt \
      --replace "endfunction()" "endfunction()''\nadd_subdirectory(builtins)''\nadd_subdirectory(shadowcallstack)"

    # Could not launch llvm-config in /build/source/runtimes/build/bin
    mkdir -p build/bin
    ln -s ${llvm}/bin/llvm-config build/bin
  '';

  extraLicenses = [ lib.licenses.mit ];
}
