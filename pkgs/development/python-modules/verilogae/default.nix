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
  version = "24.0.2mob-unstable-2026-10-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenVAF";
    repo = "OpenVAF-Reloaded";
    rev = "b6622cd8befed2ae2293593ff50ee7d5caa21f2c";
    hash = "sha256-cikGoam99rxbaPlfb977cNAEeajvgr4dNPCf8JZyYbE=";
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
    hash = "sha256-NFO88d/4uiBYd81TQFL4J3gmfFyTVnQ5I113jTaCvA0=";
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
