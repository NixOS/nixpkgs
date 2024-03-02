{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-component";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "v${version}";
    hash = "sha256-MYJxwJuiBbZQzCpFoJ/iKv6ShkCYJIMu+QQEURHRBAU=";
  };

  cargoHash = "sha256-qh6/e4ya0+ZPYIJRYe87F65tWO3ZllZpIw9B5jE+YbU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # requires the wasm32-wasi target
  doCheck = false;

  meta = with lib; {
    description = "A Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    changelog = "https://github.com/bytecodealliance/cargo-component/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "cargo-component";
  };
}
