{
  stdenv,
  callPackage,
  rocmUpdateScript,
  llvm,
  clang,
  spirv-llvm-translator,
}:

let
  spirv = (spirv-llvm-translator.override { inherit llvm; });
in
callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildDocs = false; # No documentation to build
  buildMan = false; # No man pages to build
  targetName = "libclc";
  targetDir = targetName;
  extraBuildInputs = [ spirv ];

  # `spirv-mesa3d` isn't compiling with LLVM 15.0.0, it does with LLVM 14.0.0
  # Try removing the `spirv-mesa3d` and `clspv` patches next update
  # `clspv` tests fail, unresolved calls
  extraPostPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "find_program( LLVM_CLANG clang PATHS \''${LLVM_BINDIR} NO_DEFAULT_PATH )" \
        "find_program( LLVM_CLANG clang PATHS \"${clang}/bin\" NO_DEFAULT_PATH )" \
      --replace "find_program( LLVM_SPIRV llvm-spirv PATHS \''${LLVM_BINDIR} NO_DEFAULT_PATH )" \
        "find_program( LLVM_SPIRV llvm-spirv PATHS \"${spirv}/bin\" NO_DEFAULT_PATH )" \
      --replace "  spirv-mesa3d-" "" \
      --replace "  spirv64-mesa3d-" "" \
      --replace "NOT \''${t} MATCHES" \
        "NOT \''${ARCH} STREQUAL \"clspv\" AND NOT \''${ARCH} STREQUAL \"clspv64\" AND NOT \''${t} MATCHES"
  '';

  checkTargets = [ ];
  isBroken = true; # ROCm 5.7.0 doesn't have IR/AttributeMask.h yet...?
}
