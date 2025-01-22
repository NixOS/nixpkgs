{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  symlinkJoin,
  substituteAll,
  cmake,
  clang,
  clr,
  rocm-core,
  rocm-thunk,
  rocm-device-libs,
  roctracer,
  rocdbgapi,
  rocm-smi,
  hsa-amd-aqlprofile-bin,
  numactl,
  libpciaccess,
  libxml2,
  elfutils,
  mpi,
  systemd,
  gtest,
  python3Packages,
  gpuTargets ? clr.gpuTargets,
}:

let
  rocmtoolkit-merged = symlinkJoin {
    name = "rocmtoolkit-merged";

    paths = [
      rocm-core
      rocm-thunk
      rocm-device-libs
      roctracer
      rocdbgapi
      rocm-smi
      hsa-amd-aqlprofile-bin
      clr
    ];

    postBuild = ''
      rm -rf $out/nix-support
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocprofiler";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-yzgw9g5cHAZpdbU44+1ScZyUcZ2I4GGfjbm9GSqCClk=";
  };

  patches = [
    # These just simply won't build
    ./0000-dont-install-tests-hsaco.patch

    # Fix bad paths
    (substituteAll {
      src = ./0001-fix-shell-scripts.patch;
      rocmtoolkit_merged = rocmtoolkit-merged;
    })

    # Fix for missing uint32_t not defined
    ./0002-include-stdint-in-version.patch
  ];

  nativeBuildInputs = [
    cmake
    clang
    clr
    python3Packages.lxml
    python3Packages.cppheaderparser
    python3Packages.pyyaml
    python3Packages.barectf
    python3Packages.pandas
  ];

  buildInputs = [
    numactl
    libpciaccess
    libxml2
    elfutils
    mpi
    systemd
    gtest
  ];

  propagatedBuildInputs = [ rocmtoolkit-merged ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
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

    substituteInPlace tests-v2/featuretests/profiler/CMakeLists.txt \
      --replace "--build-id=sha1" "--build-id=sha1 --rocm-path=${clr} --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode"

    substituteInPlace test/CMakeLists.txt \
      --replace "\''${ROCM_ROOT_DIR}/amdgcn/bitcode" "${rocm-device-libs}/amdgcn/bitcode"
  '';

  postInstall = ''
    # Why do these not already have the executable bit set?
    chmod +x $out/lib/rocprofiler/librocprof-tool.so
    chmod +x $out/share/rocprofiler/tests-v1/test/ocl/SimpleConvolution

    # Why do these have the executable bit set?
    chmod -x $out/libexec/rocprofiler/counters/basic_counters.xml
    chmod -x $out/libexec/rocprofiler/counters/derived_counters.xml
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm/rocprofiler";
    license = with licenses; [ mit ]; # mitx11
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor clr.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
