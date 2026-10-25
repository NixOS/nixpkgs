{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  clr,
  rocm-cmake,
  rocm-runtime,
  rocprofiler-register,
  rocprof-trace-decoder,
  aqlprofile,
  rocm-comgr,
  rocmUpdateScript,
  rccl,
  python3,
  python3Packages,
  libdrm,
  elfutils,
  sqlite,
  otf2,
  zlib,
  zstd,
  xz,
  numactl,
  fmt,
  glog,
  gtest,
  fetchpatch,
  yaml-cpp,
  elfio,
  nlohmann_json,
  makeWrapper,
  gpuTargets ? (clr.localGpuTargets or clr.gpuTargets),
  buildTests ? false,
  buildSamples ? false,
}:

# FIXME: devendor remaining git submodules:
#   external/cereal     -> https://github.com/jrmadsen/cereal
#   external/gotcha     -> https://github.com/jrmadsen/GOTCHA
#   external/perfetto   -> https://github.com/google/perfetto
#   external/ptl        -> https://github.com/jrmadsen/PTL

# rocprofiler-sdk is the home of rocprofv3
stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler-sdk";
  version = "7.2.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "rocm-${finalAttrs.version}";
    hash = "sha256-7XCxu917Mgp3SQAKlTWj3ympgwOYW3aJFcOv/GhPk1c=";
    fetchSubmodules = true;
    sparseCheckout = [
      "projects/rocprofiler-sdk"
    ];
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocprofiler-sdk";

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    clr
    python3
    makeWrapper
  ];

  buildInputs = [
    clr
    rocm-cmake
    rocm-runtime
    rocprofiler-register
    aqlprofile
    rocm-comgr
    libdrm
    elfutils
    sqlite
    otf2
    zlib
    zstd
    xz
    numactl
    fmt
    glog
    gtest
    yaml-cpp
    elfio
    nlohmann_json
    rccl
    python3Packages.pybind11
  ];

  patches = [
    (fetchpatch {
      # Fix missing amd_comgr linkage in pc-sampling integration test
      url = "https://github.com/ROCm/rocm-systems/commit/94a4595a5d02bc066f7a32e1b2134a99a5231213.patch";
      hash = "sha256-86Fx0bKL0pvXTwVN8QJL+yzCbMYkmMaKzcU4PYcW6ig=";
      relative = "projects/rocprofiler-sdk";
    })
  ]
  ++ [
    # Just the missing CPackComponent reference sourced from this commit:
    # https://github.com/ROCm/rocm-systems/commit/86ee7b2eb2273adaf1181ef9a6b2091465c6f0c7
    ./0001-fix-missing-CPackComponent-cmake-include.patch
  ]
  ++ [
    # Can be removed when a release contains the changes found in this pr:
    # https://github.com/ROCm/rocm-systems/pull/4721
    ./0002-allow-using-system-yaml-dependency.patch
    ./0003-allow-using-system-elfio-dependency.patch
    ./0004-allow-using-system-otf2-dependency.patch
    ./0005-allow-using-system-json-dependency.patch
    ./0006-fix-amd-comgr-resolution.patch
  ]
  ++ [
    # Sourced from several commits that address issues with fmt, dropping conflicting changes no longer needed to build
    # https://github.com/ROCm/rocm-systems/commit/36d9d33d90879bfbd406498011070ebd929a56b1
    # https://github.com/ROCm/rocm-systems/commit/e2f588592ecfb0653ed5b3078753186325adf70a
    # https://github.com/ROCm/rocm-systems/commit/86ee7b2eb2273adaf1181ef9a6b2091465c6f0c7 (just the fmt changes)
    ./0007-fix-missing-includes-and-api-changes-with-fmt-v12.2..patch
  ]
  ++ [
    # One new import failure added to source commit:
    # https://github.com/ROCm/rocm-systems/pull/4721/changes/f7f24a54cbe55425fbefc87c7a3d0f4c85224948
    # which is also part of https://github.com/ROCm/rocm-systems/pull/4721
    ./0008-fix-compilation-errors-from-missing-includes.patch
  ]
  ++ [
    # Prevent a segfault on `import torch` (and other consumers that link
    # librocprofiler-sdk for tracing) when OpenMP auto-discovers our
    # ompt_start_tool before glog is initialized. Upstream incidentally fixes
    # this by dropping glog in rocm-systems d80117889b3f
    # "[rocprofiler-sdk] Migrate from glog to Abseil Logging (#4668)", which
    # is too invasive (40 files + new abseil submodule) to backport.
    ./0009-rocprofiler-sdk-guard-ompt-auto-start.patch
  ];

  postPatch = ''
    # NixOS' ROCm distribution does not support libomptarget yet
    substituteInPlace samples/CMakeLists.txt \
      --replace-fail 'add_subdirectory(openmp_target)' '# add_subdirectory(openmp_target)'
    substituteInPlace tests/CMakeLists.txt \
      --replace-fail 'add_subdirectory(openmp-tools)' '# add_subdirectory(openmp-tools)'
    substituteInPlace tests/bin/CMakeLists.txt \
      --replace-fail 'add_subdirectory(openmp)' '# add_subdirectory(openmp)'

    # This requires building perfetto's trace-processor-shell via a weird external script
    substituteInPlace tests/CMakeLists.txt \
      --replace-fail 'add_subdirectory(pytest-packages)' ""

    patchShebangs source/libexec/rocprofiler-sdk/rocprofiler-sdk-launch-compiler/rocprofiler-sdk-launch-compiler.sh
  '';

  cmakeFlags = [
    (lib.cmakeBool "ROCPROFILER_BUILD_GHC_FS" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_FMT" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_GLOG" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_GTEST" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_PYBIND11" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_YAML_CPP" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_ELFIO" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_OTF2" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_JSON" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_TESTS" buildTests)
    (lib.cmakeBool "ROCPROFILER_BUILD_SAMPLES" buildSamples)
    (lib.cmakeBool "ROCPROFILER_BUILD_BENCHMARK" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_WERROR" false)
    # rocprofiler-sdk's CMake file doesn't add this dependency properly.
    "-DCMAKE_HIP_FLAGS=-I${rocm-runtime}/include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    # Required for rocprofiler-sdk-launch-compiler.sh
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
    "--debug-find-pkg=amd_comgr"
    "--trace-source=tests/pc_sampling/CMakeLists.txt"
    "--trace-expand"
  ]
  ++ lib.optionals (buildTests || buildSamples) [
    # rocprofiler-sdk normally doesn't depend on which GPU is in the system, only when
    # building tests or samples.
    (lib.cmakeFeature "GPU_TARGETS" (lib.concatStringsSep ";" gpuTargets))
  ];
  cxxCMakeFlags = [
    "-Wno-unused-variable"
  ];

  doCheck = false; # Requires GPU

  postFixup = ''
    patchelf $out/lib/*.so \
      --add-rpath ${aqlprofile}/lib \
      --add-needed libhsa-amd-aqlprofile64.so

    wrapProgram $out/bin/rocprofv3 --add-flags "--att-library-path ${
      lib.makeLibraryPath [ rocprof-trace-decoder ]
    }"
  '';

  postInstall = ''
    mkdir -p $dev/lib $dev/share/rocprofiler-sdk
    mv $out/lib/cmake $dev/lib/
    mv $out/share/rocprofiler-sdk/{samples,tests} $dev/share/rocprofiler-sdk/
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "ROCm GPU performance analysis SDK";
    homepage = "https://github.com/ROCm/rocprofiler-sdk";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
