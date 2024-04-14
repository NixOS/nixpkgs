{ stdenv
, callPackage
, rocmUpdateScript
, llvm
, makeWrapper
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  targetName = "clang-unwrapped";
  targetDir = "clang";
  extraBuildInputs = [ llvm makeWrapper ];

  extraCMakeFlags = [
    "-DCLANG_INCLUDE_DOCS=ON"
    "-DCLANG_INCLUDE_TESTS=ON"
  ];

  extraPostPatch = ''
    # Looks like they forgot to add finding libedit to the standalone build
    ln -s ../cmake/Modules/FindLibEdit.cmake cmake/modules

    substituteInPlace CMakeLists.txt \
      --replace-fail "include(CheckIncludeFile)" "include(CheckIncludeFile)''\nfind_package(LibEdit)"

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
    # add wrapper to compress embedded accelerator-specific code
    # this makes the output of composable_kernel significantly smaller right now
    # TODO: remove this once ROCm does it out of the box
    mv $out/bin/clang-offload-bundler $out/bin/clang-offload-bundler-unwrapped
    makeWrapper $out/bin/clang-offload-bundler-unwrapped $out/bin/clang-offload-bundler \
      --add-flags '-compress'
  '';

  requiredSystemFeatures = [ "big-parallel" ];
}
