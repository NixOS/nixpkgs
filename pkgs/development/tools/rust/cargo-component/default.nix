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
  version = "unstable-2023-08-16";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "26e55d87aff076e032fbcb58b794a35d3de650dc";
    hash = "sha256-FCuFCLRLJ50ISlahMG6tL2qeeBQh1GQ/vBH6/q2zn44=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "warg-api-0.1.0" = "sha256-A5FQ/nbuzV8ockV6vOMKUEoJKeaId3oyZU1QeNpd1Zc=";
      "wit-bindgen-0.9.0" = "sha256-/ozrGPnk2gYuofU7qn2qYJb6cL+7nOzj8FF0BgbKXDY=";
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
