{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  rocm-cmake,
  clr,
  gfortran,
  gtest,
  msgpack,
  libxml2,
  python3,
  python3Packages,
  openmp,
  hipblas-common,
  tensile,
  lapack-reference,
  ncurses,
  libffi,
  zlib,
  zstd,
  rocmUpdateScript,
  buildTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
  # hipblaslt supports only devices with MFMA or WMMA
  # WMMA on gfx1100 may be broken
  # MFMA on MI100 may be broken
  # MI200/MI300 known to work
  gpuTargets ? (
    clr.localGpuTargets or [
      # "gfx908" FIXME: confirm MFMA on MI100 works
      "gfx90a"
      "gfx942"
      # "gfx1100" FIXME: confirm WMMA targets work
    ]
  ),
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    supportsTargetArches =
      (builtins.any (lib.strings.hasPrefix "gfx9") gpuTargets)
      || (builtins.any (lib.strings.hasPrefix "gfx11") gpuTargets);
    tensile' = (tensile.override { isTensileLite = true; }).overrideAttrs {
      inherit (finalAttrs) src;
      sourceRoot = "${finalAttrs.src.name}/tensilelite";
    };
    py = python3.withPackages (ps: [
      ps.pyyaml
      ps.setuptools
      ps.packaging
    ]);
    gpuTargets' = lib.optionalString supportsTargetArches (lib.concatStringsSep ";" gpuTargets);
    compiler = "amdclang++";
    cFlags = "-O3 -I${msgpack}/include"; # FIXME: cmake files need patched to include this properly
  in
  {
    pname = "hipblaslt${clr.gpuArchSuffix}";
    version = "6.3.3";

    src = fetchFromGitHub {
      owner = "ROCm";
      repo = "hipBLASLt";
      rev = "rocm-${finalAttrs.version}";
      hash = "sha256-ozfHwsxcczzYXN9SIkyfRvdtaCqlDN4bh3UHZNS2oVQ=";
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
    ]
    ++ lib.optionals buildTests [
      "test"
    ]
    ++ lib.optionals buildBenchmarks [
      "benchmark"
    ]
    ++ lib.optionals buildSamples [
      "sample"
    ];

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
        --replace-fail 'Tensile_CPU_THREADS ""' 'Tensile_CPU_THREADS "$ENV{NIX_BUILD_CORES}"'
      # FIXME: TensileCreateExtOpLibraries build failure due to unsupported null operand
      # Working around for now by disabling the ExtOp libs
      substituteInPlace library/src/amd_detail/rocblaslt/src/CMakeLists.txt \
        --replace-fail 'TensileCreateExtOpLibraries("' '# skipping TensileCreateExtOpLibraries'
      substituteInPlace library/src/amd_detail/rocblaslt/src/kernels/compile_code_object.sh \
        --replace-fail '${"\${rocm_path}"}/bin/' ""
    '';

    # Apply patches to allow building without a target arch if we need to do that
    patches = lib.optionals (!supportsTargetArches) [
      # Add ability to build without specitying any arch.
      (fetchpatch {
        sha256 = "sha256-VW3bPzmQvfo8+iKsVfpn4sbqAe41fLzCEUfBh9JxVyk=";
        url = "https://raw.githubusercontent.com/gentoo/gentoo/refs/heads/master/sci-libs/hipBLASLt/files/hipBLASLt-6.1.1-no-arch.patch";
      })
      # Followup to above patch for 6.3.x
      (fetchpatch {
        sha256 = "sha256-GCsrne6BiWzwj8TMAfFuaYz1Pij97hoCc6E3qJhWb10=";
        url = "https://raw.githubusercontent.com/gentoo/gentoo/refs/heads/master/sci-libs/hipBLASLt/files/hipBLASLt-6.3.0-no-arch-extra.patch";
      })
    ];

    doCheck = false;
    doInstallCheck = false;

    nativeBuildInputs = [
      cmake
      rocm-cmake
      py
      clr
      gfortran
      # need make to get streaming console output so nix knows build is still running
      # so deliberately not using ninja
    ];

    buildInputs = [
      hipblas-common
      tensile'
      openmp
      libffi
      ncurses

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
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      lapack-reference
    ];

    cmakeFlags = [
      "-Wno-dev"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_VERBOSE_MAKEFILE=ON"
      "-DVIRTUALENV_PYTHON_EXENAME=${lib.getExe py}"
      "-DTENSILE_USE_HIP=ON"
      "-DTENSILE_BUILD_CLIENT=OFF"
      "-DTENSILE_USE_FLOAT16_BUILTIN=ON"
      "-DCMAKE_CXX_COMPILER=${compiler}"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DHIPBLASLT_ENABLE_MARKER=Off"
      # FIXME what are the implications of hardcoding this?
      "-DTensile_CODE_OBJECT_VERSION=V5"
      "-DTensile_COMPILER=${compiler}"
      "-DAMDGPU_TARGETS=${gpuTargets'}"
      "-DGPU_TARGETS=${gpuTargets'}"
      "-DTensile_LIBRARY_FORMAT=msgpack"
    ]
    ++ lib.optionals (!supportsTargetArches) [
      "-DBUILD_WITH_TENSILE=OFF"
    ]
    ++ lib.optionals buildTests [
      "-DBUILD_CLIENTS_TESTS=ON"
    ]
    ++ lib.optionals buildBenchmarks [
      "-DBUILD_CLIENTS_BENCHMARKS=ON"
    ]
    ++ lib.optionals buildSamples [
      "-DBUILD_CLIENTS_SAMPLES=ON"
    ];

    postInstall =
      lib.optionalString buildTests ''
        mkdir -p $test/bin
        mv $out/bin/hipblas-test $test/bin
      ''
      + lib.optionalString buildBenchmarks ''
        mkdir -p $benchmark/bin
        mv $out/bin/hipblas-bench $benchmark/bin
      ''
      + lib.optionalString buildSamples ''
        mkdir -p $sample/bin
        mv $out/bin/example-* $sample/bin
      ''
      + lib.optionalString (buildTests || buildBenchmarks || buildSamples) ''
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
    passthru.tensilelite = tensile';
    meta = with lib; {
      description = "Library that provides general matrix-matrix operations with a flexible API";
      homepage = "https://github.com/ROCm/hipBLASlt";
      license = with licenses; [ mit ];
      teams = [ teams.rocm ];
      platforms = platforms.linux;
    };
  }
)
