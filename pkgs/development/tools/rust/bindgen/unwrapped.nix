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
  version = "0.72.0";

  src = fetchCrate {
    pname = "bindgen-cli";
    inherit version;
    hash = "sha256-0hIxXKq7zu/gq0QAs2Ffuq584a9w1RWctPs9SBfc0/I=";
  };

  cargoHash = "sha256-K/iM79RfNU+3f2ae6wy/FMFAD68vfqzSUebqALPJpJY=";

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
