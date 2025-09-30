{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-merged-llvm,
  clr,
  rocminfo,
  python3,
  hipify,
  gitMinimal,
  gtest,
  zstd,
  buildTests ? false,
  buildExamples ? false,
  gpuTargets ? (
    clr.localGpuTargets or [
      "gfx900"
      "gfx906"
      "gfx908"
      "gfx90a"
      "gfx942"
      "gfx1030"
      "gfx1100"
      "gfx1101"
      "gfx1102"
      "gfx1200"
      "gfx1201"
    ]
  ),
}:

stdenv.mkDerivation (finalAttrs: {
  preBuild = ''
    echo "This derivation isn't intended to be built directly and only exists to be overridden and built in chunks";
    exit 1
  '';

  pname = "composable_kernel_base";
  # Picked this version over 6.3 because much easier to get to build
  # and it matches the version torch 2.6 wants
  version = "6.4.0-unstable-2024-12-20";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ]
  ++ lib.optionals buildExamples [
    "example"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "composable_kernel";
    rev = "07339c738396ebeae57374771ded4dcf11bddf1e";
    hash = "sha256-EvEBxlOpQ71BF57VW79WBo/cdxAwTKFXFMiYKyGyyEs=";
  };

  nativeBuildInputs = [
    # Deliberately not using ninja
    # because we're jankily composing build outputs from multiple drvs
    # ninja won't believe they're up to date
    gitMinimal
    cmake
    rocminfo
    clr
    hipify
    zstd
    python3
  ];

  buildInputs = [
    rocm-cmake
    clr
    zstd
  ];

  strictDeps = true;
  enableParallelBuilding = true;
  env.ROCM_PATH = clr;
  env.HIP_CLANG_PATH = "${rocm-merged-llvm}/bin";

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/hip/cmake"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POLICY_DEFAULT_CMP0069=NEW"
    # "-DDL_KERNELS=ON" # Not needed, slow to build
    # CK_USE_CODEGEN Required for migraphx which uses device_gemm_multiple_d.hpp
    # but migraphx requires an incompatible fork of CK and fails anyway
    # "-DCK_USE_CODEGEN=ON"
    # It might be worth skipping fp64 in future with this:
    # "-DDTYPES=fp32;fp16;fp8;bf16;int8"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DBUILD_DEV=OFF"
    "-DROCM_PATH=${clr}"
    "-DCMAKE_HIP_COMPILER_ROCM_ROOT=${clr}"

    # FP8 can build for 908/90a but very slow build
    # and produces unusably slow kernels that are huge
    "-DCK_USE_FP8_ON_UNSUPPORTED_ARCH=OFF"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    # We intentionally set GPU_ARCHS and not AMD/GPU_TARGETS
    # per readme this is required if archs are dissimilar
    # In rocm-6.3.x not setting any arch flag worked
    # but setting dissimilar arches always failed
    "-DGPU_ARCHS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals buildTests [
    "-DGOOGLETEST_DIR=${gtest.src}" # Custom linker names
  ];

  # No flags to build selectively it seems...
  postPatch =
    # Reduce configure time by preventing thousands of clang-tidy targets being added
    # We will never call them
    # Never build profiler
    ''
      substituteInPlace library/src/utility/CMakeLists.txt library/src/tensor_operation_instance/gpu/CMakeLists.txt \
        --replace-fail clang_tidy_check '#clang_tidy_check'
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(profiler)" ""
    ''
    # Optionally remove tests
    + lib.optionalString (!buildTests) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(test)" ""
      substituteInPlace codegen/CMakeLists.txt \
        --replace-fail "include(ROCMTest)" ""
    ''
    # Optionally remove examples
    + lib.optionalString (!buildExamples) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(example)" ""
    '';

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/test_* $test/bin
    ''
    + lib.optionalString buildExamples ''
      mkdir -p $example/bin
      mv $out/bin/example_* $example/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  passthru.anyGfx9Target = lib.lists.any (lib.strings.hasPrefix "gfx9") gpuTargets;

  meta = with lib; {
    description = "Performance portable programming model for machine learning tensor operators";
    homepage = "https://github.com/ROCm/composable_kernel";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
    broken = true;
  };
})
