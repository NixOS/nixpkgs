{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "24.0.0mob-unstable-2026-08-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenVAF";
    repo = "OpenVAF-Reloaded";
    rev = "3369a83f9c626f6d298f9f881379f561ce432e27";
    hash = "sha256-+7Ni75QPkgHm1jh7ppiP0oRtDhmzV3OpNqpPWtGhVF4=";
  };

  # upstream's ./configure is an LLVM auto-detection script, not autotools
  dontConfigure = true;

  postPatch = ''
    substituteInPlace openvaf/osdi/build.rs \
      --replace-fail "-fPIC" ""

    # upstream no longer defaults to an LLVM version; select the one we build with
    substituteInPlace setup.py \
      --replace-fail "binding=Binding.NoBinding," \
        'binding=Binding.NoBinding, features=["llvm${lib.versions.major llvmPackages.llvm.version}"],'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-+jvaiBCmjd3RrlES+Sc1SskEMOtO1ykOdInMTH/Gazo=";
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
