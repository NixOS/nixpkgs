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
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    # rocr_debug_agent lives in the rocm-systems monorepo since ROCm 10
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/rocr-debug-agent"
      "shared"
    ];
    hash = "sha256-WpBG1ogF161EM3tgXnVGstyDBdCmTXQPUPnkZF1eF3A=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocr-debug-agent";

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

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Library that provides some debugging functionality for ROCr";
    homepage = "https://github.com/ROCm/rocr_debug_agent";
    license = lib.licenses.ncsa;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
