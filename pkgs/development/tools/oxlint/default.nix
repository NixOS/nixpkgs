{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oxlint";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "web-infra-dev";
    repo = "oxc";
    rev = "oxlint_v${version}";
    hash = "sha256-di+uCLZJNJMETMSUxQwlFaZPJps0+HIL7h+EvudP5II=";
  };

  cargoHash = "sha256-r+HRm9JNFKFL78VP/Yz87b1nQDLwbNuhHd0JkXeuCC0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "--bin=oxlint" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "A suite of high-performance tools for JavaScript and TypeScript written in Rust";
    homepage = "https://github.com/web-infra-dev/oxc";
    changelog = "https://github.com/web-infra-dev/oxc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oxlint";
  };
}
