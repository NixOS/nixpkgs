{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  cmake,
  pkg-config,
  rocm-cmake,
  clr,
  rocm-llvm,
  python3,
  tensile,
  msgpack,
  libxml2,
  gtest,
  gfortran,
  openmp,
  git,
  amd-blis,
  zstd,
  hipblas-common,
  hipblaslt,
  python3Packages,
  rocm-smi,
  writeShellScriptBin,
  buildTensile ? true,
  buildTests ? false,
  buildBenchmarks ? true,
  tensileSepArch ? true,
  tensileLazyLib ? true,
  # TODO: ideally this can be turned off depending on `gpuTargets` as hipBLASLt
  # only supports a small number of targets.
  withHipBlasLt ? false,
  # `gfx940`, `gfx941` are not present in this list because they are early
  # engineering samples, and all final MI300 hardware are `gfx942`:
  # https://github.com/NixOS/nixpkgs/pull/298388#issuecomment-2032791130
  #
  # `gfx1012` is not present in this list because the ISA compatibility patches
  # would force all `gfx101*` GPUs to run as `gfx1010`, so `gfx101*` GPUs will
  # always try to use `gfx1010` code objects, hence building for `gfx1012` is
  # useless: https://github.com/NixOS/nixpkgs/pull/298388#issuecomment-2076327152
  gpuTargets ? (
    clr.localGpuTargets or [
      "gfx900"
      "gfx906"
      "gfx908"
      "gfx90a"
      "gfx942"
      "gfx1010"
      "gfx1030"
      "gfx1100"
      "gfx1101"
      "gfx1102"
    ]
  ),
}:

# FIXME: this derivation is ludicrously large, can we do anything about this?
let
  gpuTargets' = lib.concatStringsSep ";" gpuTargets;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas${clr.gpuArchSuffix}";
  version = "6.3.1";

  outputs = [
    "out"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-IYcrVcGH4yZDkFZeNOJPfG0qsPS/WiH0fTSUSdo1BH4=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
      # no ninja, it buffers console output and nix times out long periods of no output
      rocm-cmake
      git
    ]
    ++ lib.optionals buildTensile [
      tensile
    ];

  buildInputs =
    [
      python3
      hipblas-common
      clr
    ]
    ++ lib.optionals withHipBlasLt [
      hipblaslt
    ]
    ++ lib.optionals buildTensile [
      zstd
      msgpack
      libxml2
      python3Packages.msgpack
      python3Packages.zstandard
    ]
    ++ lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      gfortran
      openmp
      amd-blis
      rocm-smi
    ]
    ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
      python3Packages.pyyaml
    ];

  env.TENSILE_ROCM_ASSEMBLER_PATH = "${clr.hipClangPath}/clang++";
  env.TENSILE_ROCM_OFFLOAD_BUNDLER_PATH = "${rocm-llvm}/bin/clang-offload-bundler";

  hardeningDisable = [ "zerocallusedregs" "stackprotector" ];

  cmakeFlags =
    [
      (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${clr.hipClangPath}/clang++")
      (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
      (lib.cmakeFeature "CMAKE_EXECUTE_PROCESS_COMMAND_ECHO" "STDERR")
      # "-DCMAKE_Fortran_COMPILER=${lib.getBin gfortran}/bin/gfortran"
      # "-DCMAKE_Fortran_COMPILER_AR=${lib.getBin gfortran}/bin/ar"
      # "-DCMAKE_Fortran_COMPILER_RANLIB=${lib.getBin gfortran}/bin/ranlib"
      # FIXME: AR and RANLIB might need passed `--plugin=$(gfortran --print-file-name=liblto_plugin.so)`
      (lib.cmakeFeature "python" "python3")
      (lib.cmakeFeature "AMDGPU_TARGETS" gpuTargets')
      (lib.cmakeBool "BUILD_WITH_TENSILE" buildTensile)
      (lib.cmakeBool "ROCM_SYMLINK_LIBS" false)
      (lib.cmakeFeature "ROCBLAS_TENSILE_LIBRARY_DIR" "lib/rocblas")
      (lib.cmakeBool "BUILD_WITH_HIPBLASLT" withHipBlasLt)
      (lib.cmakeBool "BUILD_CLIENTS_TESTS" buildTests)
      (lib.cmakeBool "BUILD_CLIENTS_BENCHMARKS" buildBenchmarks)
      (lib.cmakeBool "BUILD_CLIENTS_SAMPLES" buildBenchmarks)
      (lib.cmakeBool "BUILD_OFFLOAD_COMPRESS" true)
      (lib.cmakeBool "LINK_BLIS" true)
      # Temporarily set variables to work around upstream CMakeLists issue
      # Can be removed once https://github.com/ROCm/rocm-cmake/issues/121 is fixed
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    ]
    ++ lib.optionals buildTensile [
      (lib.cmakeFeature "Tensile_CODE_OBJECT_VERSION" "default")
      (lib.cmakeFeature "Tensile_LOGIC" "asm_full")
      (lib.cmakeFeature "Tensile_LIBRARY_FORMAT" "msgpack")
      (lib.cmakeBool "BUILD_WITH_PIP" false)
      (lib.cmakeBool "Tensile_SEPARATE_ARCHITECTURES" tensileSepArch)
      (lib.cmakeBool "Tensile_LAZY_LIBRARY_LOADING" tensileLazyLib)
    ];

  passthru.amdgpu_targets = gpuTargets';

  patches = [
    (fetchpatch {
      name = "Extend-rocBLAS-HIP-ISA-compatibility.patch";
      url = "https://github.com/GZGavinZhao/rocBLAS/commit/89b75ff9cc731f71f370fad90517395e117b03bb.patch";
      hash = "sha256-W/ohOOyNCcYYLOiQlPzsrTlNtCBdJpKVxO8s+4G7sjo=";
    })
    (fetchpatch {
      name = "find-blis-using-pkg-config.patch";
      url = "https://github.com/GZGavinZhao/rocBLAS/commit/836c7ca03f5f8cbf3d50b146abd3d22366f6e3c7.patch";
      hash = "sha256-cjSbVsMbzEPxoluQ4Du3KrAuFiYFFGHQyx15+UuWtQA=";
    })
  ];

  # Pass $NIX_BUILD_CORES to Tensile
  postPatch = ''
    substituteInPlace cmake/build-options.cmake \
      --replace-fail 'Tensile_CPU_THREADS ""' 'Tensile_CPU_THREADS "$ENV{NIX_BUILD_CORES}"'
    substituteInPlace CMakeLists.txt \
      --replace-fail "4.42.0" "4.43.0"
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "BLAS implementation for ROCm platform";
    homepage = "https://github.com/ROCm/rocBLAS";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
