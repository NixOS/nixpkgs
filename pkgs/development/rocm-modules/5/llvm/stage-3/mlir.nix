{ stdenv
, callPackage
, rocmUpdateScript
, clr
, vulkan-headers
, vulkan-loader
, glslang
, shaderc
, lit
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildDocs = false; # No decent way to hack this to work
  buildMan = false; # No man pages to build
  targetName = "mlir";
  targetDir = targetName;
  extraNativeBuildInputs = [ clr ];

  extraBuildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
    shaderc
  ];

  extraCMakeFlags = [
    "-DMLIR_INCLUDE_DOCS=ON"
    "-DMLIR_INCLUDE_TESTS=ON"
    "-DMLIR_ENABLE_ROCM_RUNNER=ON"
    "-DMLIR_ENABLE_SPIRV_CPU_RUNNER=ON"
    "-DMLIR_ENABLE_VULKAN_RUNNER=ON"
    "-DROCM_TEST_CHIPSET=gfx000" # CPU runner
  ];

  extraPostPatch = ''
    chmod +w ../llvm
    mkdir -p ../llvm/build/bin
    ln -s ${lit}/bin/lit ../llvm/build/bin/llvm-lit

    # `add_library cannot create target "llvm_gtest" because an imported target with the same name already exists`
    substituteInPlace CMakeLists.txt \
      --replace "EXISTS \''${UNITTEST_DIR}/googletest/include/gtest/gtest.h" "FALSE"

    substituteInPlace test/CMakeLists.txt \
      --replace "FileCheck count not" "" \
      --replace "list(APPEND MLIR_TEST_DEPENDS mlir_rocm_runtime)" ""

    substituteInPlace lib/ExecutionEngine/CMakeLists.txt \
      --replace "return()" ""

    # Remove problematic tests
    rm test/CAPI/execution_engine.c
    rm test/Target/LLVMIR/llvmir-intrinsics.mlir
    rm test/Target/LLVMIR/llvmir.mlir
    rm test/Target/LLVMIR/openmp-llvm.mlir
    rm test/mlir-cpu-runner/*.mlir
    rm test/mlir-vulkan-runner/*.mlir
  '';

  extraPostInstall = ''
    mkdir -p $out/bin
    mv bin/mlir-tblgen $out/bin
  '';

  checkTargets = [ "check-${targetName}" ];
  requiredSystemFeatures = [ "big-parallel" ];
  isBroken = true; # `DebugTranslation.cpp:139:10: error: no matching function for call to 'get'`
}
