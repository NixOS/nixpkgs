{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  hello,
  cmake,
  rocm-cmake,
  clr,
  python3,
  ninja,
  xz,
  writableTmpDirAsHomeHook,
  pkg-config,
  gpuTargets ? clr.localGpuTargetsWithGenericFallback or clr.gpuTargetsWithGenericFallback,
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
  py = python3.withPackages (ps: [
    ps.wheel
    ps.distutils
    ps.setuptools
    ps.packaging
    ps.pyyaml
    ps.numpy
    ps.filelock
    ps.iniconfig
    ps.pluggy
    ps.pybind11
    ps.pandas
    ps.triton
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aotriton";
  version = "0.10b";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aotriton";
    rev = "${finalAttrs.version}";
    hash = "sha256-BvqkCEpDpMe7BBvrHVKUvKol/cE3tujFGoOml+RlHE4=";
    leaveDotGit = true;
    # fetch all submodules except unused triton submodule that is ~500MB
    postFetch = ''
      cd $out
      git reset --hard HEAD
      for submodule in $(git config --file .gitmodules --get-regexp path | awk '{print $2}' | grep '^third_party/' | grep -v '^third_party/triton$'); do
        git submodule update --init --recursive "$submodule"
      done
      rm -rf .git
    '';
  };

  # Excerpt from README:
  # Note: do not run ninja separately, due to the limit of the current build system,
  # ninja install will run the whole build process unconditionally.
  dontBuild = true;
  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;
  __structuredAttrs = true;
  strictDeps = true;
  # CMake setup for aotriton is odd, tests are intended to be ran manually as test/ python scripts
  doCheck = false;
  doInstallCheck = false;
  # Only set big-parallel when we are building kernels, no-image mode build is faster
  requiredSystemFeatures = if anySupportedTargets then [ "big-parallel" ] else [ ];

  env.ROCM_PATH = "${clr}";
  env.CFLAGS = "-w -g1 -gz -Wno-c++11-narrowing";
  env.CXXFLAGS = finalAttrs.env.CFLAGS;

  nativeBuildInputs = [
    cmake
    rocm-cmake
    pkg-config
    py
    ninja
    clr
    writableTmpDirAsHomeHook # venv wants to cache in ~
  ];

  buildInputs = [
    clr
    xz
  ];

  patches = [
    # CMakeLists.txt: AOTRITON_INHERIT_SYSTEM_SITE_TRITON flag
    (fetchpatch {
      sha256 = "sha256-tBmjjhRJmLv3K6F2+4OcMuwf8dH7efPPECMQjh6QdUA=";
      url = "https://github.com/ROCm/aotriton/commit/9734c3e999c412a07d2b35671998650942b26ed4.patch";
    })
  ];

  # This is build+install due to previously mentioned jank!
  installPhase = ''
    runHook preInstall
    ninja -v install
    runHook postInstall
  '';

  cmakeFlags = [
    "-Wno-dev"
    "-DVENV_DIR=/build/venv"
    "-DVENV_BIN_PYTHON=/build/venv/bin/python"
    # Disable building kernels if no supported targets are enabled
    (lib.cmakeBool "AOTRITON_NOIMAGE_MODE" (!anySupportedTargets))
    (lib.cmakeBool "AOTRITON_INHERIT_SYSTEM_SITE_TRITON" true)
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals anySupportedTargets [
    "-DAOTRITON_TARGET_ARCH=${supportedTargets'}" # This only works on aotriton>0.10b, noop otherwise
  ];

  passthru.tests = {
    # regression test that aotriton so doesn't crash in static constructor
    # currently known to fail on rocm toolchain but fine with default stdenv
    ld-preload-into-hello = stdenv.mkDerivation {
      name = "aotriton-basic-load-test";
      nativeBuildInputs = [ hello ];
      buildCommand = ''
        set -e
        LD_PRELOAD=${finalAttrs.finalPackage}/lib/libaotriton_v2.so ${hello}/bin/hello > /dev/null
        echo "ld-preload-into-hello" > $out
      '';
    };
  };

  meta = with lib; {
    description = "ROCm Ahead of Time (AOT) Triton Math Library";
    homepage = "https://github.com/ROCm/aotriton";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
