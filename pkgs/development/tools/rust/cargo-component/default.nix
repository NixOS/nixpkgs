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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "v${version}";
    hash = "sha256-1mq6tH3jFzyzQ0nsen9r08RrXMn16O7gOz7GS3nr10I=";
  };

  cargoHash = "sha256-BtdMsJqAU9Y1QntUBymlYLJdfx9aP7hf/Za8G8D6w54=";

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
