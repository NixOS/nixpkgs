{ stdenv
, callPackage
, rocmUpdateScript
, clr
, vulkan-headers
, vulkan-loader
, glslang
, shaderc
, fetchpatch
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildDocs = false; # No decent way to hack this to work
  buildMan = false; # No man pages to build
  targetName = "mlir";
  targetDir = targetName;

  # Fix `DebugTranslation.cpp:139:10: error: no matching function for call to 'get'`
  extraPatches = [
    (fetchpatch {
      url = "https://github.com/ROCm/llvm-project/commit/f1d1e10ec7e1061bf0b90abbc1e298d9438a5e74.patch";
      hash = "sha256-3c91A9InMKxm+JcnWxoUeOU68y5I6w1AAXx6T9UByqI=";
    })
  ];
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
    # `add_library cannot create target "llvm_gtest" because an imported target with the same name already exists`
    substituteInPlace CMakeLists.txt \
      --replace-fail "EXISTS \''${UNITTEST_DIR}/googletest/include/gtest/gtest.h" "FALSE"

    # Mainly `No such file or directory`
    cat ${./1001-mlir-failing-tests.list} | xargs -d \\n rm
  '';

  extraPostInstall = ''
    mkdir -p $out/bin
    mv bin/mlir-tblgen $out/bin
  '';

  checkTargets = [ "check-${targetName}" ];
  requiredSystemFeatures = [ "big-parallel" ];
}
