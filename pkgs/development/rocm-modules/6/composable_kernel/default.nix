{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-merged-llvm,
  clr,
  rocm-device-libs,
  rocminfo,
  hipify,
  git,
  gtest,
  zstd,
  ninja,
  buildTests ? false,
  buildExamples ? false,
  # FIXME: This arch list needs to grow, had build issues and will need to test
  # but testing is very slow
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
    ]
  ),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "composable_kernel${clr.gpuArchSuffix}";
  # This version must be PEP 440 compatible because it's the version of the ck4inductor python package too
  version = "6.4.0-unstable-20241220";

  outputs =
    [
      "out"
    ]
    ++ lib.optionals buildTests [
      "test"
    ]
    ++ lib.optionals buildExamples [
      "example"
    ];

  patches = [
    # for Gentoo this gives a significant speedup in build times
    # not observing speedup. possibly because our LLVM has been patched to fix amdgpu-early-inline-all issues?
    # ./disable-amdgpu-inline.patch
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "composable_kernel";
    rev = "07339c738396ebeae57374771ded4dcf11bddf1e";
    hash = "sha256-EvEBxlOpQ71BF57VW79WBo/cdxAwTKFXFMiYKyGyyEs=";
  };

  nativeBuildInputs = [
    git
    cmake
    rocminfo
    clr
    hipify
    ninja
    zstd
  ];

  buildInputs = [
    rocm-cmake
    clr
    zstd
  ];

  strictDeps = true;
  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];
  env.ROCM_PATH = clr;
  env.HIP_CLANG_PATH = "${rocm-merged-llvm}/bin";

  cmakeFlags =
    [
      "-DCMAKE_MODULE_PATH=${clr}/hip/cmake"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POLICY_DEFAULT_CMP0069=NEW"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      # "-DDL_KERNELS=ON"
      # Not turned on because don't think deps require it, slightly speeds up build
      # "-DCK_USE_CODEGEN=ON"
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
    ''
      export HIP_DEVICE_LIB_PATH=${rocm-device-libs}/amdgcn/bitcode
    ''
    + lib.optionalString (!buildTests) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(test)" ""
      substituteInPlace codegen/CMakeLists.txt \
        --replace-fail "include(ROCMTest)" ""
    ''
    + lib.optionalString (!buildExamples) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(example)" ""
    ''
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(profiler)" ""
    '';

  # Clamp parallelism based on free memory at build start to avoid OOM
  preConfigure = ''
    export NINJA_SUMMARIZE_BUILD=1
    export NINJA_STATUS="[%r jobs | %P %f/%t @ %o/s | %w | ETA %W ] "
    MEM_GB_TOTAL=$(awk '/MemTotal/ { printf "%d \n", $2/1024/1024 }' /proc/meminfo)
    MEM_GB_AVAILABLE=$(awk '/MemAvailable/ { printf "%d \n", $2/1024/1024 }' /proc/meminfo)
    APPX_GB=$((MEM_GB_AVAILABLE > MEM_GB_TOTAL ? MEM_GB_TOTAL : MEM_GB_AVAILABLE))
    MAX_CORES=$((1 + APPX_GB / 2))
    MAX_CORES_LINK=$((1 + APPX_GB / 8))
    MAX_CORES_LINK=$((MAX_CORES_LINK > NIX_BUILD_CORES ? NIX_BUILD_CORES : MAX_CORES_LINK))
    export NIX_BUILD_CORES="$((NIX_BUILD_CORES > MAX_CORES ? MAX_CORES : NIX_BUILD_CORES))"
    echo "Picked new core limits NIX_BUILD_CORES=$NIX_BUILD_CORES MAX_CORES_LINK=$MAX_CORES_LINK based on available mem: $APPX_GB GB"
    cmakeFlagsArray+=(
      "-DCK_PARALLEL_LINK_JOBS=$MAX_CORES_LINK"
      "-DCK_PARALLEL_COMPILE_JOBS=$NIX_BUILD_CORES"
    )
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

  meta = with lib; {
    description = "Performance portable programming model for machine learning tensor operators";
    homepage = "https://github.com/ROCm/composable_kernel";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
