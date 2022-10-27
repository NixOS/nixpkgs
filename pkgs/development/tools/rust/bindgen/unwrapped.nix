{ lib, fetchFromGitHub, rustPlatform, clang, rustfmt
, runtimeShell
, bash
}:
let
  # bindgen hardcodes rustfmt outputs that use nightly features
  rustfmt-nightly = rustfmt.override { asNightly = true; };
in rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen-unwrapped";
  version = "0.59.2";

  RUSTFLAGS = "--cap-lints warn"; # probably OK to remove after update

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "sha256-bJYdyf5uZgWe7fQ80/3QsRV0qyExYn6P9UET3tzwPFs=";
  };

  cargoSha256 = "sha256-RKZY5vf6CSFaKweuuNkeFF0ZXlSUibAkcL/YhkE0MoQ=";

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
