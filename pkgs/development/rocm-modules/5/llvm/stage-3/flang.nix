{ stdenv
, callPackage
, rocmUpdateScript
, clang-unwrapped
, mlir
, python3Packages
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildTests = false; # `Executable "flang1" doesn't exist!`
  targetName = "flang";
  targetDir = targetName;
  extraNativeBuildInputs = [ python3Packages.sphinx-markdown-tables ];
  extraBuildInputs = [ mlir ];

  extraCMakeFlags = [
    "-DCMAKE_POLICY_DEFAULT_CMP0116=NEW"
    "-DCLANG_DIR=${clang-unwrapped}/lib/cmake/clang"
    "-DFLANG_INCLUDE_TESTS=OFF"
    "-DMLIR_TABLEGEN_EXE=${mlir}/bin/mlir-tblgen"
  ];

  extraPostPatch = ''
    substituteInPlace test/CMakeLists.txt \
      --replace "FileCheck" "" \
      --replace "count" "" \
      --replace "not" ""

    substituteInPlace docs/CMakeLists.txt \
      --replace "CLANG_TABLEGEN_EXE clang-tblgen" "CLANG_TABLEGEN_EXE ${clang-unwrapped}/bin/clang-tblgen"
  '';
}
