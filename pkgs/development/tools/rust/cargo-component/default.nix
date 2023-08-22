{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  pname = "cargo-component";
  version = "unstable-2023-08-19";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "4abbb89ed356887a5b7e822c507cc1d02cbe8935";
    hash = "sha256-MZQcyK8AN/TRplTNuPkNMFFdJIlWxHEB4W6z5PnFDxw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "warg-api-0.1.0" = "sha256-A5FQ/nbuzV8ockV6vOMKUEoJKeaId3oyZU1QeNpd1Zc=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # requires the wasm32-wasi target
  doCheck = false;

  meta = with lib; {
    description = "A Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
