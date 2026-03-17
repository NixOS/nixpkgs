{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
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
  llvm,
  elfutils,
  mpi,
  gtest,
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
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/rocprofiler";
    hash = "sha256-0Bhg4RVKU5LjOHoeeCVHBWIL216ydDkAPPyAaTqkSoo=";
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
  pname = "rocprofiler";
  inherit (source) version src sourceRoot;

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
    llvm.clang-unwrapped
    llvm.llvm
    numactl
    libpciaccess
    libxml2
    elfutils
    mpi
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

  passthru.rocmtoolkit-merged = rocmtoolkit-merged;

  meta = {
    inherit (source) homepage;
    description = "Profiling with perf-counters and derived metrics";
    license = with lib.licenses; [ mit ]; # mitx11
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
