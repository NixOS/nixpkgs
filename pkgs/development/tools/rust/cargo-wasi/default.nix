{ lib
, rustPlatform
, fetchCrate
, pkg-config
, stdenv
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wasi";
  version = "0.1.26";

  src = fetchCrate {
    inherit version;
    pname = "cargo-wasi-src";
    sha256 = "sha256-/u5GKqGwJWS6Gzc1WZ7O5ZSHHGoqBVZ4jQDEIfAyciE=";
  };

  cargoSha256 = "sha256-eF3HrulY7HrKseCYyZyC2EuWboFvmia2qLymBxvopKI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # Checks need to be disabled here because the current test suite makes assumptions
  # about the surrounding environment that aren't Nix friendly. See these lines for specifics:
  # https://github.com/bytecodealliance/cargo-wasi/blob/0.1.26/tests/tests/support.rs#L13-L18
  doCheck = false;

  meta = with lib; {
    description = "A lightweight Cargo subcommand to build code for the wasm32-wasi target";
    homepage = "https://bytecodealliance.github.io/cargo-wasi";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
