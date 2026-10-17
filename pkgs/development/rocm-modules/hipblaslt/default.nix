{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rocm-cmake,
  amdsmi,
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
    ps.msgpack
    # tensilelite imports joblib (Parallel.py) and lists it in requirements.txt.
    ps.joblib
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
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    tag = "therock-${finalAttrs.version}";
    hash = "sha256-FOwC+eG8dYgiktogDrUZhtKbKl9iNFvnGXSt0Uj02lQ=";
    sparseCheckout = [
      "projects/hipblaslt"
      "shared"
    ];
    # Compress the 5ish GiB of yaml files so this .src is under output size limit
    postFetch = ''
      find $out -name '*.yaml' -path '*/Tensile/Logic/*' -exec ${lib.getExe zstd} --rm {} \;
    '';
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
  # tensilelite has a helper-kernel .hsaco cache (HelperKernelCache) that defaults to $HOME/.tensile/helper_cache. $HOME is /homeless-shelter
  # (unwritable) in the Nix sandbox, so the code-object compile phase crashes with
  # PermissionError on mkdir. Cross-invocation caching is useless under Nix anyway
  # (each build compiles every kernel once), so disable it via the upstream switch.
  env.TENSILE_DISABLE_HELPER_CACHE = "1";
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
  ];

  preConfigure = ''
    find . -name '*.yaml.zst' -path '*/Tensile/Logic/*' -exec zstd -d --rm {} \;
  '';

  # Belt-and-suspenders for the $HOME=/homeless-shelter problem above: point $HOME
  # at a writable dir so any *other* tensilelite step that writes under $HOME during
  # the (~7h) code-object compile phase doesn't fail after the fact. Cheap insurance
  # given how long a full-matrix rebuild takes to reach that phase.
  preBuild = ''
    export HOME=$TMPDIR
  '';

  postPatch = ''
    # The shared dep `origami` (pulled via add_subdirectory) requires Git only to
    # guard a FetchContent fallback that downloads rocm-cmake, which we never hit
    # (ROCmCMakeBuildTools is provided + -DROCM_FOUND=ON), so drop the hard requirement.
    substituteInPlace ../../shared/origami/cmake/dependencies.cmake \
      --replace-fail "find_package(Git REQUIRED)" ""

    # The new shared dep `stinkytofu` unconditionally `include(ClangTidy)` +
    # `add_clang_tidy_custom_target()` from the monorepo's top-level cmake/modules
    # (not in our sparse checkout of projects/hipblaslt+shared). It's a dev-lint
    # target only (ENABLE_CLANG_TIDY defaults OFF), so drop both calls. (The
    # sibling default_amdclang.cmake includes are guarded to standalone builds,
    # which we are not, so they never fire here.)
    substituteInPlace ../../shared/stinkytofu/CMakeLists.txt \
      --replace-fail 'include(ClangTidy)' "" \
      --replace-fail 'add_clang_tidy_custom_target()' ""

    # messagepack-compression-support.patch calls ZSTD_* in MessagePack.cpp
    # (compiled into the tensilelite-host static lib). The amdclang toolchain
    # ignores NIX_LDFLAGS (same reason cFlags passes -I for zstd/blis by hand),
    # so link libzstd explicitly here; PRIVATE on a static lib propagates the
    # requirement to every consumer (hipblaslt-bench, libhipblaslt.so, tests).
    echo 'target_link_libraries(tensilelite-host PRIVATE ${lib.getLib zstd}/lib/libzstd.so)' \
      >> tensilelite/src/msgpack/CMakeLists.txt
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
    amdsmi
    zstd
  ];

  buildInputs = [
    llvm.llvm
    clr
    rocm-cmake
    hipblas-common
    amd-blis
    amdsmi
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
    # cmake >= 4.4 re-runs cmake mid-build (`--regenerate-during-build`) when Tensile codegen writes into a
    # CONFIGURE_DEPENDS-globbed path. On that reconfigure rocisa's FetchContent
    # nanobind is already populated, so FetchContent_MakeAvailable no longer
    # re-runs add_subdirectory and `nanobind_add_module`
    # (tensilelite/rocisa/CMakeLists.txt:109) is left undefined -> configure dies.
    # The target graph does not change mid-build, so suppress the spurious
    # regeneration rule (Ninja generator honours this).
    (lib.cmakeBool "CMAKE_SUPPRESS_REGENERATION" true)
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
      ${lib.optionalString buildTests ''
        mkdir -p $test/bin
        mv $out/bin/hipblas-test $test/bin
      ''}
      ${lib.optionalString buildSamples ''
        mkdir -p $sample/bin
        mv $out/bin/example-* $sample/bin
      ''}
      # $out is the library output and keeps no bin/. Everything installed there is
      # a client/benchmark tool + its yaml/py support (hipblaslt-cotenant{,-kernel},
      # hipblaslt-perf, bench, api-overhead, ...), so after routing any test/sample binaries above, move the rest to
      # $benchmark wholesale rather than an explicit list that breaks on new tools.
      mv $out/bin/* $benchmark/bin
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
  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };
  meta = {
    description = "Library that provides general matrix-matrix operations with a flexible API";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblaslt";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
