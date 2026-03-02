{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  python3,
  clr,
  rocdbgapi,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocr-debug-agent";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocr_debug_agent";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-zW92HyK4nGcDaJxmBaHeURAivs6dU059WxaywL6dAk4=";
  };

  nativeBuildInputs = [
    cmake
    clr
    python3 # TODO: check for scripts that need patchShebangs in output
  ];

  buildInputs = [
    rocdbgapi
    elfutils
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${clr}"
    "-DHIP_PATH=${clr}"
  ];

  # Weird install target
  postInstall = ''
    rm -rf $out/src
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "Library that provides some debugging functionality for ROCr";
    homepage = "https://github.com/ROCm/rocr_debug_agent";
    license = with lib.licenses; [ ncsa ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
