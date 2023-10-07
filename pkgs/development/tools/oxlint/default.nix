{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oxlint";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "web-infra-dev";
    repo = "oxc";
    rev = "oxlint_v${version}";
    hash = "sha256-2Ne0RqwAX0uHWJLAgDRTipSjjWl2Va71uo06IgI9f0Y=";
  };

  cargoHash = "sha256-WI8EvFEz0lflt93YZbGORCLLop7k44yI9r2I1y+Gjkk=";

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
