{ callPackage
, rocmUpdateScript
, llvm
}:

callPackage ../base.nix rec {
  inherit rocmUpdateScript;
  targetName = "clang-unwrapped";
  targetDir = "clang";
  extraBuildInputs = [ llvm ];

  extraCMakeFlags = [
    "-DCLANG_INCLUDE_DOCS=ON"
    "-DCLANG_INCLUDE_TESTS=ON"
  ];

  extraPostPatch = ''
    # Looks like they forgot to add finding libedit to the standalone build
    ln -s ../cmake/Modules/FindLibEdit.cmake cmake/modules

    substituteInPlace CMakeLists.txt \
      --replace "include(CheckIncludeFile)" "include(CheckIncludeFile)''\nfind_package(LibEdit)"

    # `No such file or directory: '/build/source/clang/tools/scan-build/bin/scan-build'`
    rm test/Analysis/scan-build/*.test
    rm test/Analysis/scan-build/rebuild_index/rebuild_index.test

    # `does not depend on a module exporting 'baz.h'`
    rm test/Modules/header-attribs.cpp

    # We do not have HIP or the ROCm stack available yet
    rm test/Driver/hip-options.hip

    # ???? `ld: cannot find crti.o: No such file or directory` linker issue?
    rm test/Interpreter/dynamic-library.cpp

    # `fatal error: 'stdio.h' file not found`
    rm test/OpenMP/amdgcn_emit_llvm.c
  '';

  extraPostInstall = ''
    mv bin/clang-tblgen $out/bin
  '';

  requiredSystemFeatures = [ "big-parallel" ];
}
