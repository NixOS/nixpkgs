{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rocm-cmake,
  rocm-smi,
  pkg-config,
  clr,
  gfortran,
  gtest,
  boost,
  llvm,
  msgpack-cxx,
  amd-blis,
  libxml2,
  python3,
  python3Packages,
  openmp,
  hipblas-common,
  lapack-reference,
  ncurses,
  ninja,
  libffi,
  jemalloc,
  zlib,
  zstd,
  rocmUpdateScript,
  buildTests ? false,
  buildSamples ? false,
  # hipblaslt supports only devices with MFMA or WMMA
  gpuTargets ? (clr.localGpuTargets or clr.gpuTargets),
}:

let
  # hipblaslt is extremely particular about what it will build with
  # so intersect with a known supported list and use only those
  supportedTargets = (
    lib.lists.intersectLists gpuTargets [
      "gfx908"
      "gfx90a"
      "gfx942"
      "gfx950"
      "gfx1100"
      "gfx1101"
      # 7.x "gfx1150"
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
    ps.msgpack
  ]);
  # workaround: build for one working target if no targets are supported
  # a few CXX files are still build for the device
  gpuTargets' =
    if supportsTargetArches then (lib.concatStringsSep ";" supportedTargets) else "gfx1200";
  compiler = "amdclang++";
  # no-switch due to spammy warnings on some cases with fixme messages
  # FIXME(LunNova@): cmake files need patched to include this properly or
  # maybe we improve the toolchain to use config files + assemble a sysroot
  # so system wide include assumptions work
  cFlags = "-Wno-switch -fopenmp -I${lib.getDev zstd}/include -I${amd-blis}/include/blis/ -I${lib.getDev msgpack-cxx}/include";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblaslt${clr.gpuArchSuffix}";
  version = "6.5-unstable-2025-08-21";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    rev = "a676499add42941ff6af1e8d3f0504416dac7429";
    hash = "sha256-zIYdHFbHyP2V6dkx6Ueb6NBqWu8tJji2hSWF9zWEJa4=";
    sparseCheckout = [ "projects/hipblaslt" ];
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hipblaslt";
  env.CXX = compiler;
  env.CFLAGS = cFlags;
  env.CXXFLAGS = cFlags;
  env.ROCM_PATH = "${clr}";
  env.TENSILE_ROCM_ASSEMBLER_PATH = lib.getExe' clr "amdclang++";
  env.TENSILE_GEN_ASSEMBLY_TOOLCHAIN = lib.getExe' clr "amdclang++";
  env.LD_PRELOAD = "${jemalloc}/lib/libjemalloc.so";
  env.MALLOC_CONF = "background_thread:true,metadata_thp:auto,dirty_decay_ms:10000,muzzy_decay_ms:10000";
  requiredSystemFeatures = [ "big-parallel" ];

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    # benchmarks are non-optional
    "benchmark"
  ]
  ++ lib.optionals buildTests [
    "test"
  ]
  ++ lib.optionals buildSamples [
    "sample"
  ];

  patches = [
    # Upstream issue requesting properly specifying
    # parallel-jobs for these invocations
    # https://github.com/ROCm/rocm-libraries/issues/1242
    ./parallel-buildSourceCodeObjectFile.diff
    # Support loading zstd compressed .dat files, required to keep output under
    # hydra size limit
    ./messagepack-compression-support.patch
    # [hipblaslt] Refactor Parallel.py to drop joblib, massively reduce peak disk space usage
    # https://github.com/ROCm/rocm-libraries/pull/2073
    ./TensileCreateLibrary-refactor.patch
    ./Tensile-interning.patch
  ];

  postPatch = ''
    # git isn't needed and we have no .git
    substituteInPlace cmake/dependencies.cmake \
      --replace-fail "find_package(Git REQUIRED)" ""
    substituteInPlace CMakeLists.txt \
      --replace-fail " LANGUAGES CXX" " LANGUAGES CXX C ASM"
  '';

  doCheck = false;
  doInstallCheck = true;

  nativeBuildInputs = [
    cmake
    rocm-cmake
    py
    clr
    gfortran
    pkg-config
    ninja
    rocm-smi
    zstd
  ];

  buildInputs = [
    llvm.llvm
    clr
    rocm-cmake
    hipblas-common
    amd-blis
    rocm-smi
    openmp
    libffi
    ncurses
    lapack-reference

    # Tensile deps - not optional, building without tensile isn't actually supported
    msgpack-cxx
    libxml2
    python3Packages.msgpack
    zlib
    zstd
  ]
  ++ lib.optionals buildTests [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeFeature "Boost_INCLUDE_DIR" "${lib.getDev boost}/include") # msgpack FindBoost fails to find boost
    (lib.cmakeFeature "GPU_TARGETS" gpuTargets')
    (lib.cmakeBool "BUILD_TESTING" buildTests)
    (lib.cmakeBool "HIPBLASLT_ENABLE_BLIS" true)
    (lib.cmakeBool "HIPBLASLT_BUILD_TESTING" buildTests)
    (lib.cmakeBool "HIPBLASLT_ENABLE_SAMPLES" buildSamples)
    (lib.cmakeBool "HIPBLASLT_ENABLE_DEVICE" supportsTargetArches)
    # FIXME: Enable for ROCm 7.x
    (lib.cmakeBool "HIPBLASLT_ENABLE_ROCROLLER" false)
    "-DCMAKE_C_COMPILER=amdclang"
    "-DCMAKE_HIP_COMPILER=${compiler}"
    "-DCMAKE_CXX_COMPILER=${compiler}"
    "-DROCM_FOUND=ON" # hipblaslt tries to download rocm-cmake if this isn't set
    "-DBLIS_ROOT=${amd-blis}"
    "-DBLIS_LIB=${amd-blis}/lib/libblis-mt.so"
    "-DBLIS_INCLUDE_DIR=${amd-blis}/include/blis/"
    "-DBLA_PREFER_PKGCONFIG=ON"
    "-DFETCHCONTENT_SOURCE_DIR_NANOBIND=${python3Packages.nanobind.src}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DHIPBLASLT_ENABLE_MARKER=Off"
  ];

  postInstall =
    # Compress msgpack .dat files to stay under hydra output size limit
    # Relies on messagepack-compression-support.patch
    ''
      for file in $out/lib/hipblaslt/library/*.dat; do
        zstd -19 --long -f "$file" -o "$file.tmp" && mv "$file.tmp" "$file"
      done
    ''
    # Move binaries to appropriate outputs and delete leftover /bin
    + ''
      mkdir -p $benchmark/bin
      mv $out/bin/hipblaslt-{api-overhead,sequence,bench*} $out/bin/*.yaml $out/bin/*.py $benchmark/bin
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

  installCheckPhase =
    # Verify compression worked and .dat files aren't huge
    ''
      runHook preInstallCheck
      find "$out" -type f -name "*.dat" -size "+2M" -exec sh -c '
          echo "ERROR: oversized .dat file, check for issues with install compression: {}" >&2
          exit 1
      ' {} \;
      echo "Verified .dat files in $out are not huge"
      runHook postInstallCheck
    '';

  # If this is false there are no kernels in the output lib
  # supporting the target device
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
})
