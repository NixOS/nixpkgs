{ lib, fetchCrate, rustPlatform, clang, rustfmt
, runtimeShell
, bash
}:
let
  # bindgen hardcodes rustfmt outputs that use nightly features
  rustfmt-nightly = rustfmt.override { asNightly = true; };
in rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen-unwrapped";
  version = "0.63.0";

  src = fetchCrate {
    pname = "bindgen-cli";
    inherit version;
    sha256 = "sha256-qynsHbcljbJyi4wq9AxEE7KIclnDqNTMFAW366JhBSo=";
  };

  cargoSha256 = "sha256-nOPJo6vWMAcG9VG03uceYyLiJfomFERViDCZ0vFnenY=";

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
    maintainers = with maintainers; [ johntitor ralith ];
    mainProgram = "bindgen";
    platforms = platforms.unix;
  };
}
