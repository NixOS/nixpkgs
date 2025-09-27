{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  symlinkJoin,
  cmake,
  clang,
  clr,
  aqlprofile,
  rocm-core,
  rocm-runtime,
  rocm-device-libs,
  roctracer,
  rocdbgapi,
  numactl,
  libpciaccess,
  libxml2,
  elfutils,
  mpi,
  systemd,
  gtest,
  git,
  python3Packages,
  gpuTargets ? clr.gpuTargets,
}:

let
  rocmtoolkit-merged = symlinkJoin {
    name = "rocmtoolkit-merged";

    paths = [
      rocm-core
      rocm-runtime
      rocm-device-libs
      roctracer
      rocdbgapi
      clr
    ];

    postBuild = ''
      rm -rf $out/nix-support
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocprofiler";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-CgW8foM4W3K19kUK/l8IsH2Q9DHi/z88viXTxhNqlHQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    clang
    clr
    git
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
    aqlprofile
  ];

  propagatedBuildInputs = [ rocmtoolkit-merged ];

  #HACK: rocprofiler's cmake doesn't add these deps properly
  env.CXXFLAGS = "-I${libpciaccess}/include -I${numactl.dev}/include -I${rocmtoolkit-merged}/include -I${elfutils.dev}/include -w";

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

    substituteInPlace cmake_modules/rocprofiler_utils.cmake \
      --replace-fail 'function(ROCPROFILER_CHECKOUT_GIT_SUBMODULE)' 'function(ROCPROFILER_CHECKOUT_GIT_SUBMODULE)
      return()'

    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(ROCPROFILER_BUILD_TESTS ON)' ""

    substituteInPlace tests-v2/featuretests/profiler/CMakeLists.txt \
      --replace "--build-id=sha1" "--build-id=sha1 --rocm-path=${clr} --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode"

    substituteInPlace test/CMakeLists.txt \
      --replace "\''${ROCM_ROOT_DIR}/amdgcn/bitcode" "${rocm-device-libs}/amdgcn/bitcode"
  '';

  postInstall = ''
    # Why do these have the executable bit set?
    chmod -x $out/libexec/rocprofiler/counters/*.xml
    # rocprof shell script wants to find it in the same bin dir, easiest to symlink in
    ln -s ${clr}/bin/rocm_agent_enumerator $out/bin/rocm_agent_enumerator
  '';

  postFixup = ''
    patchelf $out/lib/*.so \
      --add-rpath ${aqlprofile}/lib \
      --add-needed libhsa-amd-aqlprofile64.so
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };
  passthru.rocmtoolkit-merged = rocmtoolkit-merged;

  meta = with lib; {
    description = "Profiling with perf-counters and derived metrics";
    homepage = "https://github.com/ROCm/rocprofiler";
    license = with licenses; [ mit ]; # mitx11
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
