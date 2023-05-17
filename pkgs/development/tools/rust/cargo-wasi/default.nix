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
  version = "0.1.27";

  src = fetchCrate {
    inherit version;
    pname = "cargo-wasi-src";
    sha256 = "sha256-u6+Fn/j2cvpBqTIfyPC8jltcCKGimFcu4NiMFCAfmwg=";
  };

  cargoHash = "sha256-Hi5Z5TmiHXp7YrqXfbwACKEximksQRhdoMGU1iLmXOk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # Checks need to be disabled here because the current test suite makes assumptions
  # about the surrounding environment that aren't Nix friendly. See these lines for specifics:
  # https://github.com/bytecodealliance/cargo-wasi/blob/0.1.27/tests/tests/support.rs#L13-L18
  doCheck = false;

  meta = with lib; {
    description = "A lightweight Cargo subcommand to build code for the wasm32-wasi target";
    homepage = "https://bytecodealliance.github.io/cargo-wasi";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
