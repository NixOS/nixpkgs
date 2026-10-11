{
  lib,
  stdenv,
  numactl,
  libpciaccess,
  libxml2,
  elfutils,
  glog,
  fmt,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  clang,
  python3Packages,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler-register";
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${lib.versions.majorMinor finalAttrs.version}";
    sparseCheckout = [
      "projects/rocprofiler-register"
      "shared"
    ];
    hash = "sha256-/y+ZerbaSKyHfEttomNtmF5zccnpqsQFNw/5gjGBuyA=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocprofiler-register";

  nativeBuildInputs = [
    cmake
    clang
  ];

  buildInputs = [
    numactl
    libpciaccess
    libxml2
    elfutils
    glog
    fmt

    python3Packages.lxml
    python3Packages.cppheaderparser
    python3Packages.pyyaml
    python3Packages.barectf
    python3Packages.pandas
  ];
  cmakeFlags = [
    "-DROCPROFILER_REGISTER_BUILD_TESTS=0"
    "-DROCPROFILER_REGISTER_BUILD_SAMPLES=0"
    "-DROCPROFILER_REGISTER_BUILD_GLOG=OFF"
    "-DROCPROFILER_REGISTER_BUILD_FMT=OFF"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-register";
    license = lib.licenses.mit; # mitx11
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
