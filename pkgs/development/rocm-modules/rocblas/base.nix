{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  diffutils,
  python3,
  tensile,
  boost,
  msgpack-cxx,
  libxml2,
  gtest,
  gfortran,
  openmp,
  gitMinimal,
  amd-blis,
  zstd,
  roctracer,
  hipblas-common,
  hipblaslt,
  python3Packages,
  amdsmi,
  pkg-config,
  removeReferencesTo,
  buildTensile ? true,
  buildTests ? true,
  buildBenchmarks ? true,
  tensileSepArch ? true,
  tensileLazyLib ? true,
  withHipBlasLt ? true,
  gpuTargets ? (clr.localGpuTargets or clr.gpuTargets),
}:

let
  gpuTargets' = lib.concatStringsSep ";" gpuTargets;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas${clr.gpuArchSuffix}";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    rev = "therock-${lib.versions.majorMinor finalAttrs.version}";
    sparseCheckout = [
      "projects/rocblas"
      "shared"
    ];
    hash = "sha256-8LdII9gSFxuBeJwfQgOW+1/M33nbuR6TwcrD4k6W0Oo=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocblas";

  outputs = [ "out" ] ++ lib.optional buildBenchmarks "benchmark" ++ lib.optional buildTests "test";

  nativeBuildInputs = [
    cmake
    # no ninja, it buffers console output and nix times out long periods of no output
    rocm-cmake
    clr
    gitMinimal
    pkg-config
    removeReferencesTo
  ]
  ++ lib.optionals buildTensile [
    tensile
  ];

  buildInputs = [
    python3
    hipblas-common
    roctracer
    openmp
    amd-blis
  ]
  ++ lib.optionals withHipBlasLt [
    hipblaslt
  ]
  ++ lib.optionals buildTensile [
    zstd
    msgpack-cxx
    libxml2
    python3Packages.msgpack
    python3Packages.zstandard
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    gtest
    gfortran
    # therock-10.0 rocBLAS clients switched rocm_smi -> amd_smi
    # (clients/CMakeLists.txt: find_package(amd_smi CONFIG REQUIRED))
    amdsmi
  ]
  ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
    python3Packages.pyyaml
  ];

  env.CXXFLAGS = "-fopenmp -I${lib.getDev boost}/include -I${hipblas-common}/include -I${roctracer}/include";
  # Fails to link tests with undefined symbol: cblas_*
  env.LDFLAGS =
    "-Wl,--as-needed -lzstd" + lib.optionalString (buildTests || buildBenchmarks) " -lcblas";
  env.TENSILE_ROCM_ASSEMBLER_PATH = "${stdenv.cc}/bin/clang++";

  cmakeFlags = [
    (lib.cmakeFeature "Boost_INCLUDE_DIR" "${lib.getDev boost}/include") # msgpack FindBoost fails to find boost
    (lib.cmakeFeature "CMAKE_EXECUTE_PROCESS_COMMAND_ECHO" "STDERR")
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER" "${lib.getBin gfortran}/bin/gfortran")
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER_AR" "${lib.getBin gfortran}/bin/ar")
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER_RANLIB" "${lib.getBin gfortran}/bin/ranlib")
    (lib.cmakeFeature "python" "python3")
    (lib.cmakeFeature "SUPPORTED_TARGETS" gpuTargets')
    (lib.cmakeFeature "AMDGPU_TARGETS" gpuTargets')
    (lib.cmakeFeature "GPU_TARGETS" gpuTargets')
    (lib.cmakeBool "BUILD_WITH_TENSILE" buildTensile)
    (lib.cmakeBool "ROCM_SYMLINK_LIBS" false)
    (lib.cmakeFeature "ROCBLAS_TENSILE_LIBRARY_DIR" "lib/rocblas")
    (lib.cmakeBool "BUILD_WITH_HIPBLASLT" withHipBlasLt)
    (lib.cmakeBool "BUILD_CLIENTS_TESTS" buildTests)
    (lib.cmakeBool "BUILD_CLIENTS_BENCHMARKS" buildBenchmarks)
    (lib.cmakeBool "BUILD_CLIENTS_SAMPLES" buildBenchmarks)
    (lib.cmakeBool "BUILD_OFFLOAD_COMPRESS" true)
    # # Temporarily set variables to work around upstream CMakeLists issue
    # # Can be removed once https://github.com/ROCm/rocm-cmake/issues/121 is fixed
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ]
  ++ lib.optionals buildTensile [
    "-DCPACK_SET_DESTDIR=OFF"
    "-DLINK_BLIS=ON"
    "-DBLAS_LIBRARY=${amd-blis}/lib/libblis-mt.so"
    "-DBLIS_INCLUDE_DIR=${amd-blis}/include/blis/"
    "-DBLA_PREFER_PKGCONFIG=ON"
    "-DTensile_CODE_OBJECT_VERSION=default"
    "-DTensile_LOGIC=asm_full"
    "-DTensile_LIBRARY_FORMAT=msgpack"
    (lib.cmakeBool "BUILD_WITH_PIP" false)
    (lib.cmakeBool "Tensile_SEPARATE_ARCHITECTURES" tensileSepArch)
    (lib.cmakeBool "Tensile_LAZY_LIBRARY_LOADING" tensileLazyLib)
  ];

  # NOTE(rocm-10): dropped the GZGavinZhao "Extend rocBLAS HIP ISA compatibility"
  # patch (49f21f3c). It was a workaround for older rocBLAS lacking explicit
  # gfx906/gfx90c handling — it removed the gfx1011/gfx1012 cases and added a
  # fuzzy `gfx90*→gfx900` / `gfx103*→gfx1030` fallback. therock-10.0's
  # library/src/handle.cpp now has explicit Processor::gfx906/gfx90c/... cases
  # (which take priority over any fuzzy fallback), so with gfx906 kept in
  # gpuTargets, Tensile builds real gfx906 kernels — strictly better than the
  # patch's gfx900 fallback.
  patches = [ ];

  # Pass $NIX_BUILD_CORES to Tensile
  postPatch = ''
    substituteInPlace cmake/build-options.cmake \
      --replace-fail 'Tensile_CPU_THREADS ""' 'Tensile_CPU_THREADS "$ENV{NIX_BUILD_CORES}"'
  ''
  # Workaround: libblis detection uses broken absolute paths
  # TODO: upstream a proper fix
  + ''
    substituteInPlace clients/CMakeLists.txt \
      --replace-fail "if ( NOT WIN32 )" "if(OFF)" \
      --replace-fail "else() # WIN32" "elseif(OFF)"
  ''
  # Fixes sh: line 1: /usr/bin/diff: No such file or directory
  # /build/source/clients/gtest/../include/testing_logging.hpp:1117: Failure
  + lib.optionalString buildTests ''
    substituteInPlace clients/include/testing_logging.hpp \
      --replace-fail "/usr/bin/diff" "${lib.getExe' diffutils "diff"}"
  '';

  postInstall =
    # tensile isn't needed at runtime and pulls in ~400MB of python deps
    ''
      remove-references-to -t ${tensile} \
        "$out/lib/librocblas.so."*
    ''
    + lib.optionalString buildBenchmarks ''
      moveToOutput "bin/*-tune" "$benchmark"
      moveToOutput "bin/*-bench" "$benchmark"
      moveToOutput "bin/*example*" "$benchmark"
      cp "$out/bin/"*.{yaml,txt} "$benchmark/bin"
    ''
    + lib.optionalString buildTests ''
      moveToOutput "bin/*test*" "$test"
      cp "$out/bin/"*.{yaml,txt} "$test/bin"
    ''
    + ''
      # The rocBLAS library output keeps no bin/ (clients live in $test /
      # $benchmark). therock-10.0 also drops a bin/rocblas/ CTest scaffolding
      # dir here alongside the client yaml/txt, so remove the whole bin/ tree
      # rather than rmdir'ing (which fails on the non-empty directory).
      rm -rf $out/bin
    '';

  passthru = {
    amdgpu_targets = gpuTargets';
    updateScript = rocmUpdateScript { inherit finalAttrs; };
  };

  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "BLAS implementation for ROCm platform";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocblas";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
