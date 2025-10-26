{
  lib,
  stdenv,
  rocm-runtime,
  rocprofiler,
  numactl,
  libpciaccess,
  libxml2,
  elfutils,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  clang,
  clr,
  python3Packages,
  gpuTargets ? clr.gpuTargets,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler-register";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocprofiler-register";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-HaN4XMHuCRDfKOpfuZ2SkOEQfAZKouh6luqbtATUYm0=";
    fetchSubmodules = true;
  };

  # vendored glog is too old and breaks on CMake 4, gets bumped in ROCm 7.0
  postPatch = ''
    substituteInPlace external/glog/cmake/GetCacheVariables.cmake \
      --replace-fail "(VERSION 3.3)" "(VERSION 3.5)"
  '';

  nativeBuildInputs = [
    cmake
    clang
    clr
  ];

  # TODO(@LunNova): use system fmt&glog once upstream fixes flag to not vendor
  buildInputs = [
    numactl
    libpciaccess
    libxml2
    elfutils
    rocm-runtime

    rocprofiler.rocmtoolkit-merged

    python3Packages.lxml
    python3Packages.cppheaderparser
    python3Packages.pyyaml
    python3Packages.barectf
    python3Packages.pandas
  ];
  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${clr}"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    "-DBUILD_TEST=OFF"
    "-DROCPROFILER_BUILD_TESTS=0"
    "-DROCPROFILER_BUILD_SAMPLES=0"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  passthru.updateScript = rocmUpdateScript {
    name = "rocprofiler-register";
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm/rocprofiler";
    license = with licenses; [ mit ]; # mitx11
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
