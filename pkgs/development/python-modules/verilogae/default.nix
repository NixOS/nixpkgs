{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-rust,
  rustPlatform,
  cargo,
  rustc,
  autoPatchelfHook,
  pkg-config,
  llvmPackages_15,
  libxml2,
  ncurses,
  zlib,
}:

buildPythonPackage rec {
  pname = "verilogae";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pascalkuthe";
    repo = "OpenVAF";
    rev = "VerilogAE-v${version}";
    hash = "sha256-TILKKmgSyhyxp88sdflDXAoH++iP6CMpdoXN1/1fsjU=";
  };

  postPatch = ''
    substituteInPlace openvaf/llvm/src/initialization.rs \
      --replace-fail "i8" "libc::c_char"
    substituteInPlace openvaf/osdi/build.rs \
      --replace-fail "-fPIC" ""
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-/gSqaxqOZUkUmJJ5PGMkAG/5PSeAjwDjT2ce+tL7xmY";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    autoPatchelfHook
    pkg-config
    llvmPackages_15.clang
    llvmPackages_15.llvm
  ];

  buildInputs = [
    libxml2.dev
    llvmPackages_15.libclang
    ncurses
    zlib
  ];

  cargoBuildType = "release";

  pythonImportsCheck = [ "verilogae" ];

  hardeningDisable = [ "pic" ];

  meta = {
    description = "Verilog-A tool useful for compact model parameter extraction";
    homepage = "https://man.sr.ht/~dspom/openvaf_doc/verilogae/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jasonodoom
      jleightcap
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
