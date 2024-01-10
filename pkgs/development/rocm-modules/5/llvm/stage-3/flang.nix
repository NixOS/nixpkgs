{ stdenv
, callPackage
, rocmUpdateScript
, clang-unwrapped
, mlir
, graphviz
, python3Packages
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  targetName = "flang";
  targetDir = targetName;

  extraNativeBuildInputs = [
    graphviz
    python3Packages.sphinx-markdown-tables
  ];

  extraBuildInputs = [ mlir ];

  extraCMakeFlags = [
    "-DCLANG_DIR=${clang-unwrapped}/lib/cmake/clang"
    "-DMLIR_TABLEGEN_EXE=${mlir}/bin/mlir-tblgen"
    "-DCLANG_TABLEGEN_EXE=${clang-unwrapped}/bin/clang-tblgen"
    "-DFLANG_INCLUDE_TESTS=OFF" # `The dependency target "Bye" of target ...`
  ];

  # `flang/lib/Semantics/check-omp-structure.cpp:1905:1: error: no member named 'v' in 'Fortran::parser::OmpClause::OmpxDynCgroupMem'`
  isBroken = true;
}
