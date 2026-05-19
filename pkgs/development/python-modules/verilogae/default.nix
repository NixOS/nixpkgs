{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  nix-update-script,
  setuptools-rust,
  rustPlatform,
  cargo,
  rustc,
  pkg-config,
  llvmPackages,
  libxml2,
  ncurses,
  zlib,
}:

buildPythonPackage.override { stdenv = llvmPackages.stdenv; } rec {
  pname = "verilogae";
  version = "24.0.0mob-unstable-2025-07-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenVAF";
    repo = "OpenVAF-Reloaded";
    rev = "d878f5519b1767b64c6ebeb4d67e29e7cd46e60b";
    hash = "sha256-TDE2Ewokhm2KSKe+sunUbV8KD3kaTSd5dB3CLCWGJ9U=";
  };

  # segfault in pythonImportsCheckPhase
  disabled = pythonAtLeast "3.14";

  postPatch = ''
    substituteInPlace openvaf/osdi/build.rs \
      --replace-fail "-fPIC" ""
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-5SLrVL3h6+tptHv3GV7r8HUTrYQC9VdF68O2/Uct3xA=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    pkg-config
    llvmPackages.llvm
  ];

  buildInputs = [
    libxml2.dev
    llvmPackages.libclang
    ncurses
    zlib
  ];

  cargoBuildType = "release";

  pythonImportsCheck = [ "verilogae" ];

  hardeningDisable = [ "pic" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Verilog-A tool useful for compact model parameter extraction";
    homepage = "https://man.sr.ht/~dspom/openvaf_doc/verilogae/";
    downloadPage = "https://github.com/OpenVAF/OpenVAF-Reloaded";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jasonodoom
      jleightcap
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
