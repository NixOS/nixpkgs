{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  rocm-cmake,
  clr,
  python3,
  ninja,
  xz,
  writableTmpDirAsHomeHook,
  pkg-config,
  gpuTargets ? clr.localGpuTargets or clr.gpuTargets,
  # for passthru.tests
  aotriton,
  hello,
}:
let
  supportedTargets = lib.lists.intersectLists [
    # aotriton GPU support list:
    # https://github.com/ROCm/aotriton/blob/main/v2python/gpu_targets.py
    "gfx90a"
    "gfx942"
    "gfx950"
    "gfx1100"
    "gfx1151"
    "gfx1150"
    "gfx1201"
    "gfx1200"
  ] gpuTargets;
  supportedTargets' = lib.concatStringsSep ";" supportedTargets;
  anySupportedTargets = supportedTargets != [ ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aotriton";
  version = "0.10b";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aotriton";
    tag = finalAttrs.version;
    hash = "sha256-stAHnsqChkNv69wjlhM/qUetrJpNwI1i7rGnPMwsNz0=";
    leaveDotGit = true;
    # fetch all submodules except unused triton submodule that is ~500MB
    postFetch = ''
      cd $out
      git reset --hard HEAD
      for submodule in $(git config --file .gitmodules --get-regexp path | awk '{print $2}' | grep '^third_party/' | grep -v '^third_party/triton$'); do
        git submodule update --init --recursive "$submodule"
      done
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;
  __structuredAttrs = true;
  strictDeps = true;
  # Only set big-parallel when we are building kernels, no-image mode build is faster
  requiredSystemFeatures = if anySupportedTargets then [ "big-parallel" ] else [ ];

  env = {
    ROCM_PATH = "${clr}";
    CFLAGS = "-w -g1 -gz -Wno-c++11-narrowing";
    CXXFLAGS = finalAttrs.env.CFLAGS;
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    pkg-config
    python3
    ninja
    clr
    writableTmpDirAsHomeHook # venv wants to cache in ~
  ];

  buildInputs = [
    clr
    xz
  ]
  ++ (with python3.pkgs; [
    wheel
    packaging
    pyyaml
    numpy
    filelock
    iniconfig
    pluggy
    pybind11
    pandas
    triton
  ]);

  patches = [
    # CMakeLists.txt: AOTRITON_INHERIT_SYSTEM_SITE_TRITON flag
    (fetchpatch {
      url = "https://github.com/ROCm/aotriton/commit/9734c3e999c412a07d2b35671998650942b26ed4.patch";
      hash = "sha256-tBmjjhRJmLv3K6F2+4OcMuwf8dH7efPPECMQjh6QdUA=";
    })
  ];

  # Excerpt from README:
  # Note: do not run ninja separately, due to the limit of the current build system,
  # ninja install will run the whole build process unconditionally.
  dontBuild = true;
  # This builds+installs
  installPhase = ''
    runHook preInstall
    ninja -v install
    runHook postInstall
  '';
  # tests are intended to be ran manually as test/ python scripts and need accelerator
  doCheck = false;
  doInstallCheck = false;

  # Need to set absolute paths to VENV and its PYTHON or
  # build fails with "AOTRITON_INHERIT_SYSTEM_SITE_TRITON is enabled
  # but triton is not available … no such file or directory"
  # Set via a preConfigure hook so a valid absolute path can be
  # picked if nix-shell is used against this package
  preConfigure = ''
    cmakeFlagsArray+=(
      "-DVENV_DIR=$(pwd)/aotriton-venv/"
      "-DVENV_BIN_PYTHON=$(pwd)/aotriton-venv/bin/python"
    )
  '';

  cmakeFlags = [
    # Disable building kernels if no supported targets are enabled
    (lib.cmakeBool "AOTRITON_NOIMAGE_MODE" (!anySupportedTargets))
    # Use preinstalled triton from our python's site-packages
    (lib.cmakeBool "AOTRITON_INHERIT_SYSTEM_SITE_TRITON" true)
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ]
  ++ lib.optionals anySupportedTargets [
    # Note: build will warn "AMDGPU_TARGETS was not set, and system GPU detection was unsuccsesful."
    # but this can safely be ignored, aotriton uses a different approach to pass targets
    (lib.cmakeFeature "AOTRITON_TARGET_ARCH" supportedTargets')
  ];

  passthru.tests = {
    # regression test that aotriton so doesn't crash in static constructor
    # currently known to fail on rocm toolchain but fine with default stdenv
    ld-preload-into-hello = stdenv.mkDerivation {
      name = "aotriton-basic-load-test";
      nativeBuildInputs = [ hello ];
      buildCommand = ''
        set -e
        LD_PRELOAD=${
          aotriton.override {
            gpuTargets = [ ];
          }
        }/lib/libaotriton_v2.so ${hello}/bin/hello > /dev/null
        echo "ld-preload-into-hello" > $out
      '';
    };
  };

  meta = {
    description = "ROCm Ahead of Time (AOT) Triton Math Library";
    homepage = "https://github.com/ROCm/aotriton";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
    # ld: error: unable to insert .comment after .comment
    broken = stdenv.cc.isClang;
  };
})
