{
  lib,
  stdenv,
  rocmSystemsSrc,
  rocmSystemsVersion,
  rocm-runtime,
  rocprofiler,
  numactl,
  libpciaccess,
  libxml2,
  elfutils,
  cmake,
  clang,
  clr,
  python3Packages,
  gpuTargets ? clr.gpuTargets,
}:

stdenv.mkDerivation {
  pname = "rocprofiler-register";
  version = rocmSystemsVersion;

  src = rocmSystemsSrc;
  sourceRoot = "${rocmSystemsSrc.name}/projects/rocprofiler-register";

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

  meta = {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-register";
    license = with lib.licenses; [ mit ]; # mitx11
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
