{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
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

let
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/rocprofiler-register";
    hash = "sha256-2u5rLLT4Aif0jwAqqlIzrzh9kICJG15nZAslbiL7H9g=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
      fetchSubmodules = true;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation {
  pname = "rocprofiler-register";
  inherit (source) version src sourceRoot;

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
    inherit (source) homepage;
    description = "Profiling with perf-counters and derived metrics";
    license = with lib.licenses; [ mit ]; # mitx11
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
