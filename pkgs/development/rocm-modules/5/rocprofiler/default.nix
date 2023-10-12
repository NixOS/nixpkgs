{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, clang
, clr
, rocm-thunk
, roctracer
, rocm-smi
, hsa-amd-aqlprofile-bin
, numactl
, libpciaccess
, libxml2
, elfutils
, mpi
, gtest
, python3Packages
, gpuTargets ? [
  "gfx900"
  "gfx906"
  "gfx908"
  "gfx90a"
  "gfx940"
  "gfx941"
  "gfx942"
  "gfx1030"
  "gfx1100"
  "gfx1101"
  "gfx1102"
]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "rocprofiler";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-ue/2uiLbhOv/5XY4cIJuZ8DUMRhniYgxolq9xMwO1FY=";
  };

  nativeBuildInputs = [
    cmake
    clang
    clr
    python3Packages.lxml
    python3Packages.cppheaderparser
    python3Packages.pyyaml
    python3Packages.barectf
  ];

  buildInputs = [
    rocm-thunk
    rocm-smi
    hsa-amd-aqlprofile-bin
    numactl
    libpciaccess
    libxml2
    elfutils
    mpi
    gtest
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
    "-DPROF_API_HEADER_PATH=${roctracer.src}/inc/ext"
    "-DHIP_ROOT_DIR=${clr}"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postPatch = ''
    patchShebangs .

    # Cannot find ROCm device library, pointless
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(tests-v2)" "" \
      --replace "add_subdirectory(samples)" ""
  '';

  postBuild = ''
    # HSACO aren't being built for some reason
    substituteInPlace test/cmake_install.cmake \
      --replace "file(INSTALL DESTINATION \"\''${CMAKE_INSTALL_PREFIX}/share/rocprofiler/tests-v1\" TYPE FILE FILES \"" "message(\""
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm-Developer-Tools/rocprofiler";
    license = with licenses; [ mit ]; # mitx11
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor clr.version;
  };
})
