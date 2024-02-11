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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "v${version}";
    hash = "sha256-FmaJUdi3hJEd0Fo4tgzne47aP8U/SK+S0UDVEG/P6e8=";
  };

  cargoHash = "sha256-8Shw3YSHBFHkw57ZVNjJo/eg2fXvyTVKM9kPX17pfkM=";

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
