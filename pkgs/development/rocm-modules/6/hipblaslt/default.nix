{
  lib,
  stdenv,
  fetchpatch2,
  fetchFromGitHub,
  cmake,
  rocm-cmake,
  rocm-smi,
  pkg-config,
  clr,
  gfortran,
  gtest,
  msgpack,
  amd-blis,
  libxml2,
  python3,
  python3Packages,
  openmp,
  hipblas-common,
  lapack-reference,
  ncurses,
  libdrm,
  libffi,
  zlib,
  zstd,
  rocmUpdateScript,
  buildTests ? false,
  buildSamples ? false,
  # hipblaslt supports only devices with MFMA or WMMA
  gpuTargets ? (clr.localGpuTargetsWithGenericFallback or clr.gpuTargetsWithGenericFallback),
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    # hipblaslt is extremely particular about what it will build with
    # so intersect with a known supported list and use only those
    # if empty, apply patch to allow skipping tensile build and producing
    # a hipblaslt that has no kernels and never works
    # but allows deps like torch that insist on linking hipblaslt to be built
    supportedTargets = (
      lib.lists.intersectLists gpuTargets [
        "gfx908"
        "gfx90a"
        "gfx942"
        "gfx950"
        "gfx1100"
        "gfx1101"
        "gfx1150"
        "gfx1151"
        "gfx1200"
        "gfx1201"
      ]
    );
    supportsTargetArches = supportedTargets != [ ];
    py = python3.withPackages (ps: [
      ps.pyyaml
      ps.setuptools
      ps.packaging
      ps.nanobind
      ps.joblib
      ps.msgpack
    ]);
    gpuTargets' =
      if supportsTargetArches then (lib.concatStringsSep ";" supportedTargets) else "gfx90a";
    compiler = "amdclang++";
    cFlags = "-O3 -I${msgpack}/include -I${libdrm.dev}/include -I${openmp.dev}/include"; # FIXME: cmake files need patched to include this properly
  in
  {
    pname = "hipblaslt${clr.gpuArchSuffix}";
    version = "6.4.2-unstable-20250422";

    src = fetchFromGitHub {
      owner = "ROCm";
      repo = "hipBLASLt";
      rev = "926edeeb8cecf95905eec84717e12c176ad11cd7";
      hash = "sha256-QS/15IDjkGl4+t7XLLRp7BI5g2F+IDyzIJW5DdbXSc0=";
    };
    env.CXX = compiler;
    env.CFLAGS = cFlags;
    env.CXXFLAGS = cFlags;
    env.ROCM_PATH = "${clr}";
    env.TENSILE_ROCM_ASSEMBLER_PATH = lib.getExe' clr "amdclang++";
    env.TENSILE_GEN_ASSEMBLY_TOOLCHAIN = lib.getExe' clr "amdclang++";
    # Some tensile scripts look for this as an env var rather than a cmake flag
    env.CMAKE_CXX_COMPILER = lib.getExe' clr "amdclang++";
    requiredSystemFeatures = [ "big-parallel" ];

    outputs = [
      "out"
      "benchmark"
    ]
    ++ lib.optionals buildTests [
      "test"
    ]
    ++ lib.optionals buildSamples [
      "sample"
    ];

    # opt-in to bstefanuk's overhauled cmake build
    # because it manages to set up python paths that actually work!
    cmakeDir = "../next-cmake";

    # TODO: In 7.x the extop shell scripts are going away
    # we can likely reenable the build for them after that
    # See https://github.com/ROCm/hipBLASLt/commit/56a26228bf9d595dad74598ce43b2831572fefc3
    postPatch = ''
      mkdir -p build/Tensile/library
      # git isn't needed and we have no .git
      substituteInPlace cmake/Dependencies.cmake \
        --replace-fail "find_package(Git REQUIRED)" ""
      substituteInPlace CMakeLists.txt \
        --replace-fail "include(virtualenv)" "" \
        --replace-fail "virtualenv_install(\''${Tensile_TEST_LOCAL_PATH})" "" \
        --replace-fail "virtualenv_install(\''${CMAKE_SOURCE_DIR}/tensilelite)" "" \
        --replace-fail 'find_package(Tensile 4.33.0 EXACT REQUIRED HIP LLVM OpenMP PATHS "''${INSTALLED_TENSILE_PATH}")' "find_package(Tensile)" \
        --replace-fail 'Tensile_CPU_THREADS ""' 'Tensile_CPU_THREADS "$ENV{NIX_BUILD_CORES}"' \
        --replace-fail 'if( ''${OS_PLATFORM} STREQUAL "rhel")' \
              'if( DEFINED OS_PLATFORM AND "''${OS_PLATFORM}" STREQUAL "rhel")'
      substituteInPlace library/src/amd_detail/rocblaslt/src/extops/CMakeLists.txt \
        --replace-fail 'PYTHONPATH=' 'PYTHONPATH_ignored='
      substituteInPlace next-cmake/CMakeLists.txt \
        --replace-fail " LANGUAGES CXX" " LANGUAGES CXX C ASM"
      substituteInPlace tensilelite/HostLibraryTests/CMakeLists.txt tensilelite/Tensile/Source/CMakeLists.txt \
        --replace-fail 'target_compile_options(custom_openmp_cxx INTERFACE "-fopenmp")' \
        'target_link_libraries(custom_openmp_cxx INTERFACE OpenMP::OpenMP_CXX)'
    '';

    doCheck = false;
    doInstallCheck = false;

    nativeBuildInputs = [
      cmake
      rocm-cmake
      py
      clr
      gfortran
      pkg-config
      # need make to get streaming console output so nix knows build is still running
      # so deliberately not using ninja
    ];

    buildInputs = [
      hipblas-common
      amd-blis
      rocm-smi
      openmp
      libffi
      ncurses
      lapack-reference

      # Tensile deps - not optional, building without tensile isn't actually supported
      msgpack # FIXME: not included in cmake!
      libxml2
      python3Packages.msgpack
      python3Packages.joblib
      zlib
      zstd
    ]
    ++ lib.optionals buildTests [
      gtest
    ];

    env.LDFLAGS = "-Wl,--as-needed -L${openmp}/lib -lomp";
    cmakeFlags = [
      "-Wno-dev"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_VERBOSE_MAKEFILE=ON"
      "-DVIRTUALENV_PYTHON_EXENAME=${lib.getExe py}"
      "-DTENSILE_USE_HIP=ON"
      "-DTENSILE_BUILD_CLIENT=OFF"
      "-DTENSILE_USE_FLOAT16_BUILTIN=ON"
      "-DCMAKE_CXX_COMPILER=${compiler}"
      "-DUSE_ROCROLLER=OFF"
      "-DROCM_FOUND=ON"
      "-DBLIS_LIB=${amd-blis}/lib/libblis-mt.so"
      "-DBLIS_INCLUDE_DIR=${amd-blis}/include/blis/"
      "-DHIPBLASLT_USE_ROCROLLER=OFF"
      "-DFETCHCONTENT_SOURCE_DIR_NANOBIND=${python3Packages.nanobind.src}"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DHIPBLASLT_ENABLE_MARKER=Off"
      "-DTensile_COMPILER=${compiler}"
      # "-DAMDGPU_TARGETS=${gpuTargets'}"
      "-DGPU_TARGETS=${gpuTargets'}"
      "-DTensile_LIBRARY_FORMAT=msgpack"
      "-DOpenMP_C_INCLUDE_DIR=${openmp.dev}/include"
      "-DOpenMP_CXX_INCLUDE_DIR=${openmp.dev}/include"
      "-DOpenMP_omp_LIBRARY=${openmp}/lib"
      (lib.cmakeBool "BUILD_TESTING" buildTests)
      (lib.cmakeBool "BUILD_CLIENTS_SAMPLES" buildSamples)
      (lib.cmakeBool "BUILD_CLIENTS_TESTS" buildTests)
      (lib.cmakeBool "BUILD_CLIENTS_BENCHMARKS" true)
      (lib.cmakeBool "HIPBLASLT_BUILD_TESTING" buildTests)
      (lib.cmakeBool "HIPBLASLT_ENABLE_SAMPLES" buildSamples)
    ]
    ++ lib.optionals (!supportsTargetArches) [
      "-DBUILD_WITH_TENSILE=OFF"
    ];

    postInstall = ''
      mkdir -p $benchmark/bin
      mv $out/bin/hipblaslt-{sequence,bench*} $out/bin/*.yaml $out/bin/*.py $benchmark/bin
      ${lib.optionalString buildTests ''
        mkdir -p $test/bin
        mv $out/bin/hipblas-test $test/bin
      ''}
      ${lib.optionalString buildSamples ''
        mkdir -p $sample/bin
        mv $out/bin/example-* $sample/bin
      ''}
      rmdir $out/bin
    '';
    # If this is false there are no kernels in the output lib
    # and it's useless at runtime
    # so if it's an optional dep it's best to not depend on it
    # Some packages like torch need hipblaslt to compile
    # and are fine ignoring it at runtime if it's not supported
    # so we have to support building an empty hipblaslt
    passthru.supportsTargetArches = supportsTargetArches;
    passthru.updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      inherit (finalAttrs.src) owner repo;
    };
    meta = with lib; {
      description = "Library that provides general matrix-matrix operations with a flexible API";
      homepage = "https://github.com/ROCm/hipBLASlt";
      license = with licenses; [ mit ];
      teams = [ teams.rocm ];
      platforms = platforms.linux;
    };
  }
)
