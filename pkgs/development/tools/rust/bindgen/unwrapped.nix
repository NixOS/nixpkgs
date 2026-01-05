{
  lib,
  fetchCrate,
  rustPlatform,
  clang,
  rustfmt,
}:
let
  # bindgen hardcodes rustfmt outputs that use nightly features
  rustfmt-nightly = rustfmt.override { asNightly = true; };
in
rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen-unwrapped";
  version = "0.72.1";

  src = fetchCrate {
    pname = "bindgen-cli";
    inherit version;
    hash = "sha256-rhdQZcnlqVSUqvFDg0Scs1+DHGcKyazeS5H9HH7u8Fk=";
  };

  cargoHash = "sha256-YNpqVB+zdZ76Av2L+yQuBrxKvNML9+3H7ES4+7mED0E=";

  preConfigure = ''
    export LIBCLANG_PATH="${lib.getLib clang.cc}/lib"
  '';

  # Disable the "runtime" feature, so libclang is linked.
  buildNoDefaultFeatures = true;
  buildFeatures = [ "logging" ];
  checkNoDefaultFeatures = buildNoDefaultFeatures;
  checkFeatures = buildFeatures;

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
