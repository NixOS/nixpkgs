{ lib
, stdenv
, callPackage
, rocmUpdateScript
, llvm
, clang
, clang-unwrapped
# , rocm-device-libs
# , rocm-runtime
, perl
, elfutils
, lit
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildTests = false; # Too many failures, most pass
  targetName = "openmp";
  targetDir = targetName;
  extraNativeBuildInputs = [ perl ];

  extraBuildInputs = [
    # rocm-device-libs
    # rocm-runtime
    elfutils
  ];

  extraCMakeFlags = [
    "-DCMAKE_MODULE_PATH=/build/source/llvm/cmake/modules" # For docs
    "-DCLANG_TOOL=${clang}/bin/clang"
    "-DCLANG_OFFLOAD_BUNDLER_TOOL=${clang-unwrapped}/bin/clang-offload-bundler"
    "-DOPENMP_LLVM_TOOLS_DIR=${llvm}/bin"
    "-DOPENMP_LLVM_LIT_EXECUTABLE=${lit}/bin/.lit-wrapped"
    # "-DDEVICELIBS_ROOT=${rocm-device-libs.src}"
  ];

  extraPostPatch = ''
    # We can't build this target at the moment
    substituteInPlace libomptarget/DeviceRTL/CMakeLists.txt \
      --replace "gfx1010" ""
  '';

  checkTargets = [ "check-${targetName}" ];
  extraLicenses = [ lib.licenses.mit ];
}
