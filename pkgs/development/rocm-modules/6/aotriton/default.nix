{
  lib,
  stdenv,
  fetchFromGitHub,
  hello,
  cmake,
  rocm-cmake,
  clr,
  python3,
  triton,
  ninja,
  xz,
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
    triton
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
    # fetch all submodules except unused triton submodule
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
  dontStrip = true;
  # CMake setup for aotriton is odd, tests are intended to be ran manually as test/ python scripts
  doCheck = false;
  doInstallCheck = false;
  requiredSystemFeatures = if anySupportedTargets then [ "big-parallel" ] else [ ];

  env.ROCM_PATH = "${clr}";
  env.CFLAGS = "-w -g1 -gz -O3 -DNDEBUG -Wno-c++11-narrowing";
  env.CXXFLAGS = finalAttrs.env.CFLAGS;
  # env.LDFLAGS = "-Wl,--gdb-index";

  nativeBuildInputs = [
    cmake
    rocm-cmake
    pkg-config
    py
    clr
    ninja
  ];

  buildInputs = [
    triton
    xz
  ];

  # * give aotriton a preexisting venv that inherits our ready-to-go py with deps
  # * make a home dir exist because pip gets sad
  # * don't override cmakeFlags' AOTRITON_TRITON_SO path
  # * don't build triton to overwite the existing AOTRITON_TRITON_SO
  # * Fix 'ld: error: unable to insert .comment after .comment' due to broken linker scripts
  preConfigure = ''
    mkdir -p /build/tmp-home
    export HOME=/build/tmp-home
    python -m venv --system-site-packages /build/venv
    substituteInPlace CMakeLists.txt \
      --replace-fail 'execute_process(COMMAND "''${Python3_EXECUTABLE}" -m venv "''${VENV_DIR}")' "" \
      --replace-fail "pip install" "pip install --no-build-isolation" \
      --replace-fail "set(AOTRITON_TRITON_SO" "#" \
      --replace-fail 'OUTPUT "''${AOTRITON_TRITON_SO}"' 'OUTPUT unused.so'
    substituteInPlace v*python/ld_script.py \
      --replace-fail 'INSERT AFTER .comment;' ""
  '';

  # This is build+install due to previously mentioned jank!
  installPhase = ''
    runHook preInstall
    ninja -v install
    runHook postInstall
  '';

  cmakeFlags = [
    "-Wno-dev"
    "-DVENV_DIR=/build/venv"
    "-DAOTRITON_TRITON_SO=${triton}/${py.sitePackages}/triton/_C/libtriton.so"
    "-DVIRTUALENV_PYTHON_EXENAME=${lib.getExe py}"
    # Disable building kernels if no supported targets are enabled
    (lib.cmakeBool "AOTRITON_NOIMAGE_MODE" (!anySupportedTargets))
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
