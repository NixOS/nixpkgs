{
  lib,
  stdenv,
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
  writeShellScriptBin,
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
    tensile' = (tensile.override { isTensileLite = true; }).overrideAttrs {
      inherit (finalAttrs) src;
      sourceRoot = "${finalAttrs.src.name}/tensilelite";
      env.ROCM_PATH = "${clr}";
    };
    py = python3.withPackages (ps: [
      ps.pyyaml
      ps.setuptools
      ps.packaging
    ]);
    gpuTargets' = lib.concatStringsSep ";" gpuTargets;
    compiler = "hipcc"; # FIXME: amdclang++ in future
    cFlags = "-O3 -I${msgpack}/include"; # FIXME: cmake files need patched to include this properly
  in
  {
    # build will fail with llvm libcxx, must use gnu libstdcxx
    # https://github.com/llvm/llvm-project/issues/98734
    pname = "hipblaslt${clr.gpuArchSuffix}";
    version = "6.3.1";

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
    env.TENSILE_ROCM_ASSEMBLER_PATH = "${stdenv.cc}/bin/clang++";
    env.TENSILE_GEN_ASSEMBLY_TOOLCHAIN = "${stdenv.cc}/bin/clang++";
    requiredSystemFeatures = [ "big-parallel" ];

    patches = [
      ./ext-op-first.diff
    ];

    outputs =
      [
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
      rm -rf tensilelite
        #   sed -i '1i variable_watch(__CMAKE_C_COMPILER_OUTPUT)' CMakeLists.txt
        # sed -i '1i variable_watch(__CMAKE_CXX_COMPILER_OUTPUT)' CMakeLists.txt
        # sed -i '1i variable_watch(OUTPUT)' CMakeLists.txt
      mkdir -p build/Tensile/library
      # substituteInPlace tensilelite/Tensile/Ops/gen_assembly.sh \
      #   --replace-fail '. ''${venv}/bin/activate' 'set -x; . ''${venv}/bin/activate'
      # git isn't needed and we have no .git
      substituteInPlace cmake/Dependencies.cmake \
        --replace-fail "find_package(Git REQUIRED)" ""
      substituteInPlace CMakeLists.txt \
        --replace-fail "include(virtualenv)" "" \
        --replace-fail "virtualenv_install(\''${Tensile_TEST_LOCAL_PATH})" "" \
        --replace-fail "virtualenv_install(\''${CMAKE_SOURCE_DIR}/tensilelite)" "" \
        --replace-fail 'find_package(Tensile 4.33.0 EXACT REQUIRED HIP LLVM OpenMP PATHS "''${INSTALLED_TENSILE_PATH}")' "find_package(Tensile)"
      if [ -f library/src/amd_detail/rocblaslt/src/kernels/compile_code_object.sh ]; then
        substituteInPlace library/src/amd_detail/rocblaslt/src/kernels/compile_code_object.sh \
          --replace-fail '${"\${rocm_path}"}/bin/' ""
      fi
    '';

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
      # ninja
      (writeShellScriptBin "amdclang++" ''
        exec clang++ "$@"
      '')
    ];

    buildInputs =
      [
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

    cmakeFlags =
      [
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
        "-DTensile_COMPILER=${compiler}" # amdclang++ in future
        "-DAMDGPU_TARGETS=${gpuTargets'}"
        "-DGPU_TARGETS=${gpuTargets'}"
        "-DTensile_LIBRARY_FORMAT=msgpack"
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
    passthru.updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      inherit (finalAttrs.src) owner;
      inherit (finalAttrs.src) repo;
    };
    passthru.tensilelite = tensile';
    meta = with lib; {
      description = "ROCm BLAS marshalling library";
      homepage = "https://github.com/ROCm/hipBLAS";
      license = with licenses; [ mit ];
      maintainers = teams.rocm.members;
      platforms = platforms.linux;
    };
  }
)
