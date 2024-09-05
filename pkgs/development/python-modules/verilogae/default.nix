{
  buildPythonPackage,
  fetchFromSourcehut,
  stdenv,
  llvmPackages,
  rustc,
  patchelf,
  python,
  setuptools-rust,
  cargo,
  clang,
  rustPlatform,
  lib,
  zlib,
  ncurses,
  libxml2,
  pkg-config,
  pkgs,
}:

buildPythonPackage rec {
  pname = "verilogae";
  version = "0.9-beta-8";

  src = fetchFromSourcehut {
    owner = "~dspom";
    repo = "OpenVAF";
    rev = "b800153e84a8a640b07048d580fabafc25bbc841";
    hash = "sha256-NKiJrXnxwghNYtKL4s3YjvQd/r3QWe5saCYp4N4aQ8w=";
  };

  format = "other";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "salsa-0.17.0-pre.2" = "sha256-6GssvV76lFr5OzAUekz2h6f82Tn7usz5E8MSZ5DmgJw=";
    };
  };

  buildInputs = [
    llvmPackages.libllvm
    pkgs.libxml2
    ncurses.dev
    zlib
  ];

  nativeBuildInputs = [
    cargo
    clang
    rustPlatform.cargoSetupHook
    rustc
    llvmPackages.libllvm
    llvmPackages.clang
    setuptools-rust
    libxml2
    ncurses
    zlib
    patchelf
    pkg-config
  ];

  configurePhase = "true";

  buildPhase = ''
    export CC="${llvmPackages.clang}/bin/clang"
    export CXX="${llvmPackages.clang}/bin/clang++"

    export CARGO_BUILD_RUSTFLAGS="-L${llvmPackages.libllvm}/lib -lLLVMCore -lLLVMCodeGen -lLLVMTarget -lLLVMAnalysis -lLLVMSupport -lLLVMInstCombine -lLLVMTransformUtils -lLLVMScalarOpts -lLLVMInstrumentation"

    export LD_LIBRARY_PATH="${llvmPackages.libllvm}/lib:${pkgs.libxml2}/lib:${ncurses.dev}/lib:$LD_LIBRARY_PATH"
    export PKG_CONFIG_PATH="${pkgs.libxml2}/lib/pkgconfig:${ncurses.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"

    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/${python.sitePackages}/verilogae
    cp target/release/*.so $out/${python.sitePackages}/verilogae/ || echo "Failed to find shared objects in target/release"

    # Apply patchelf to fix the dynamic linker and rpath
    for bin in $out/${python.sitePackages}/verilogae/*.so; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath $LD_LIBRARY_PATH $bin
    done
  '';

  pythonImportsCheck = [ "verilogae" ];

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
