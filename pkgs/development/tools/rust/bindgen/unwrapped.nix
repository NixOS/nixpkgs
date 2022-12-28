{ lib, fetchCrate, rustPlatform, clang, rustfmt
, runtimeShell
, bash
}:
let
  # bindgen hardcodes rustfmt outputs that use nightly features
  rustfmt-nightly = rustfmt.override { asNightly = true; };
in rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen-unwrapped";
  version = "0.61.0";

  src = fetchCrate {
    pname = "bindgen-cli";
    inherit version;
    sha256 = "sha256-sKcKIAkUC2GfAZ4tJBNweXhoFzqO95iCpHgekpOyHzc=";
  };

  cargoSha256 = "sha256-P246tw5Kznpxav0LashIkLlmQGVB+aKbFUQQdmcASPw=";

  buildInputs = [ clang.cc.lib ];

  preConfigure = ''
    export LIBCLANG_PATH="${clang.cc.lib}/lib"
  '';

  doCheck = true;
  checkInputs = [ clang ];

  RUSTFMT = "${rustfmt-nightly}/bin/rustfmt";

  preCheck = ''
    # for the ci folder, notably
    patchShebangs .
  '';

  passthru = { inherit clang; };

  meta = with lib; {
    description = "Automatically generates Rust FFI bindings to C (and some C++) libraries";
    longDescription = ''
      Bindgen takes a c or c++ header file and turns them into
      rust ffi declarations.
    '';
    homepage = "https://github.com/rust-lang/rust-bindgen";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ johntitor ralith ];
    mainProgram = "bindgen";
    platforms = platforms.unix;
  };
}
