{ stdenv
, callPackage
, rocmUpdateScript
# , hip
# , rocm-comgr
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
  # extraNativeBuildInputs = [ hip ];

  extraBuildInputs = [
    # rocm-comgr
    vulkan-headers
    vulkan-loader
    glslang
    shaderc
  ];

  extraCMakeFlags = [
    "-DCMAKE_POLICY_DEFAULT_CMP0116=NEW"
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
}
