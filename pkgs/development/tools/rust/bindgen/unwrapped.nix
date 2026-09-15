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
  version = "0.73.1";

  src = fetchCrate {
    pname = "bindgen-cli";
    inherit version;
    hash = "sha256-EClYOhkZVtjQh+ix+eYUKyPETyhMnHvYZAYQbaUdP2U=";
  };

  cargoHash = "sha256-vc5+ByhCtaVSmxZGcdfrDMCrlJ0IQL+Yfjk4qGKT44c=";

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

  env.RUSTFMT = "${rustfmt-nightly}/bin/rustfmt";

  preCheck = ''
    # for the ci folder, notably
    patchShebangs .
  '';

  passthru = { inherit clang; };

  meta = {
    description = "Automatically generates Rust FFI bindings to C (and some C++) libraries";
    longDescription = ''
      Bindgen takes a c or c++ header file and turns them into
      rust ffi declarations.
    '';
    homepage = "https://github.com/rust-lang/rust-bindgen";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ johntitor ];
    mainProgram = "bindgen";
    platforms = lib.platforms.unix;
  };
}
