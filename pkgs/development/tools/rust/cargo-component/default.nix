{ lib
, rustPlatform
, fetchFromGitHub
, curl
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  pname = "cargo-component";
  version = "unstable-2023-07-05";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "84ad1dc2c383dd3335953f9d1b059aeef9a5833e";
    hash = "sha256-C066dXuGpl9bwKRh5kgN0DOjaEke84cj5ustYrM867I=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "warg-api-0.1.0" = "sha256-ElLwaOv0ifi8og2SJ6XZkjZX83IXoveicAUPBok/MLE=";
    };
  };

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    darwin.apple_sdk.frameworks.CoreFoundation
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
