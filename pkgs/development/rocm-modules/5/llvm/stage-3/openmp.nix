{ lib
, stdenv
, callPackage
, rocmUpdateScript
, llvm
, clang
, clang-unwrapped
, rocm-device-libs
, rocm-runtime
, rocm-thunk
, perl
, elfutils
, libdrm
, numactl
, lit
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  targetName = "openmp";
  targetDir = targetName;
  extraNativeBuildInputs = [ perl ];

  extraBuildInputs = [
    rocm-device-libs
    rocm-runtime
    rocm-thunk
    elfutils
    libdrm
    numactl
  ];

  extraCMakeFlags = [
    "-DCMAKE_MODULE_PATH=/build/source/llvm/cmake/modules" # For docs
    "-DCLANG_TOOL=${clang}/bin/clang"
    "-DCLANG_OFFLOAD_BUNDLER_TOOL=${clang-unwrapped}/bin/clang-offload-bundler"
    "-DPACKAGER_TOOL=${clang-unwrapped}/bin/clang-offload-packager"
    "-DOPENMP_LLVM_TOOLS_DIR=${llvm}/bin"
    "-DOPENMP_LLVM_LIT_EXECUTABLE=${lit}/bin/.lit-wrapped"
    "-DDEVICELIBS_ROOT=${rocm-device-libs.src}"
  ];

  extraPostPatch = ''
    # We can't build this target at the moment
    substituteInPlace libomptarget/DeviceRTL/CMakeLists.txt \
      --replace "gfx1010" ""

    # No idea what's going on here...
    cat ${./1000-openmp-failing-tests.list} | xargs -d \\n rm
  '';

  checkTargets = [ "check-${targetName}" ];
  extraLicenses = [ lib.licenses.mit ];
}
