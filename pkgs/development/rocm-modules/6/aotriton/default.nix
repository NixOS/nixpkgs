{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rocm-cmake,
  clr,
  rocblas,
  rocsolver,
  gtest,
  msgpack,
  libxml2,
  python3,
  python3Packages,
  openmp,
  hipblas-common,
  hipblas,
  nlohmann_json,
  triton-llvm,
  rocmlir,
  lapack-reference,
  ninja,
  ncurses,
  libffi,
  zlib,
  zstd,
  xz,
  pkg-config,
  buildTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
  gpuTargets ? [
    # aotriton GPU support list:
    # https://github.com/ROCm/aotriton/blob/main/v2python/gpu_targets.py
    "gfx90a"
    "gfx942"
    "gfx1100"
    "gfx1101"
  ],
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    py = python3.withPackages (ps: [
      ps.pyyaml
      ps.distutils
      ps.setuptools
      ps.packaging
      ps.numpy
      ps.wheel
      ps.filelock
      ps.iniconfig
      ps.pluggy
      ps.pybind11
    ]);
    gpuTargets' = lib.concatStringsSep ";" gpuTargets;
    compiler = "amdclang++";
    cFlags = "-O3 -DNDEBUG";
    cxxFlags = "${cFlags} -Wno-c++11-narrowing";
    triton-llvm' = triton-llvm;
  in
  {
    pname = "aotriton";
    version = "0.9.2b";

    src = fetchFromGitHub {
      owner = "ROCm";
      repo = "aotriton";
      rev = "${finalAttrs.version}";
      hash = "sha256-1Cf0olD3zRg9JESD6s/WaGifm3kfD12VUvjTZHpmGAE=";
      fetchSubmodules = true;
    };
    env.CXX = compiler;
    env.ROCM_PATH = "${clr}";
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

    # Need an empty cuda.h for this to compile
    # Better than pulling in unfree cuda headers
    postPatch = ''
      touch third_party/triton/third_party/nvidia/include/cuda.h
    '';

    doCheck = false;
    doInstallCheck = false;

    nativeBuildInputs = [
      cmake
      rocm-cmake
      pkg-config
      py
      clr
      ninja
    ];

    buildInputs = [
      rocblas
      rocsolver
      hipblas-common
      hipblas
      openmp
      libffi
      ncurses
      xz
      nlohmann_json
      rocmlir

      msgpack
      libxml2
      python3Packages.msgpack
      zlib
      zstd
    ]
    ++ lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      lapack-reference
    ];

    env.TRITON_OFFLINE_BUILD = 1;
    env.LLVM_SYSPATH = "${triton-llvm'}";
    env.JSON_SYSPATH = nlohmann_json;
    env.MLIR_DIR = "${triton-llvm'}/lib/cmake/mlir";
    env.CXXFLAGS = "-I/build/source/third_party/triton/third_party/nvidia/backend/include";

    # Fix up header issues in triton: https://github.com/triton-lang/triton/pull/3985/files
    preConfigure = ''
      mkdir third_party/triton/third_party/nvidia/backend/include/
      touch third_party/triton/third_party/nvidia/backend/include/cuda.h
      find third_party/triton -type f -exec sed -i 's|[<]cupti.h[>]|"cupti.h"|g' {} +
      find third_party/triton -type f -exec sed -i 's|[<]cuda.h[>]|"cuda.h"|g' {} +

      sed -i '2s;^;set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ON CACHE BOOL "ON")\n;' CMakeLists.txt
      sed -i '2s;^;set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "ON")\n;' CMakeLists.txt
      sed -i '2s;^;set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ON CACHE BOOL "ON")\n;' third_party/triton/CMakeLists.txt
      sed -i '2s;^;set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "ON")\n;' third_party/triton/CMakeLists.txt
      substituteInPlace third_party/triton/python/setup.py \
        --replace-fail "from distutils.command.clean import clean" "import setuptools;from distutils.command.clean import clean" \
        --replace-fail 'system == "Linux"' 'False'
      # Fix 'ld: error: unable to insert .comment after .comment'
      substituteInPlace v2python/ld_script.py \
        --replace-fail 'INSERT AFTER .comment;' ""

      cmakeFlagsArray+=(
        '-DCMAKE_C_FLAGS_RELEASE=${cFlags}'
        '-DCMAKE_CXX_FLAGS_RELEASE=${cxxFlags}'
      )
      prependToVar cmakeFlags "-GNinja"
      mkdir -p /build/tmp-home
      export HOME=/build/tmp-home
    '';

    # Excerpt from README:
    # Note: do not run ninja separately, due to the limit of the current build system,
    # ninja install will run the whole build process unconditionally.
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      ninja -v install
      runHook postInstall
    '';

    cmakeFlags = [
      "-Wno-dev"
      "-DAOTRITON_NOIMAGE_MODE=ON" # FIXME: Should be able to build with object code but generate_shim is failing
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_VERBOSE_MAKEFILE=ON"
      "-DVIRTUALENV_PYTHON_EXENAME=${lib.getExe py}"
      "-DCMAKE_CXX_COMPILER=${compiler}"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DAMDGPU_TARGETS=${gpuTargets'}"
      "-DGPU_TARGETS=${gpuTargets'}"
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
    meta = with lib; {
      description = "ROCm Ahead of Time (AOT) Triton Math Library ";
      homepage = "https://github.com/ROCm/aotriton";
      license = with licenses; [ mit ];
      teams = [ teams.rocm ];
      platforms = platforms.linux;
    };
  }
)
