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
  version = "unstable-2023-09-06";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "aa6e3c1168273b5cf6221fa0206f07f2ffb8567d";
    hash = "sha256-80076K+KfvFxyUxneEGAs8U7b+DoJLgUioIOTv+PWtI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "warg-api-0.1.0" = "sha256-kzxvGZUMUOueR8t1tiCpGJlPxqEHQMb1m1jhPYoatbA=";
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
