{ lib, fetchCrate, rustPlatform, clang, rustfmt
}:
let
  # bindgen hardcodes rustfmt outputs that use nightly features
  rustfmt-nightly = rustfmt.override { asNightly = true; };
in rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen-unwrapped";
  version = "0.69.4";

  src = fetchCrate {
    pname = "bindgen-cli";
    inherit version;
    hash = "sha256-5fwJq1WsL3IEcVUjsyqKdQU8VufbbPk6TglwJg3C1Gw=";
  };

  cargoHash = "sha256-UROy/MyPBKJe+EaiUIDbOYKVbge0C9LsmfnsvOLEONE=";

  buildInputs = [ clang.cc.lib ];

  preConfigure = ''
    export LIBCLANG_PATH="${clang.cc.lib}/lib"
  '';

  doCheck = true;
  nativeCheckInputs = [ clang ];

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
    maintainers = with maintainers; [ johntitor ];
    mainProgram = "bindgen";
    platforms = platforms.unix;
  };
}
