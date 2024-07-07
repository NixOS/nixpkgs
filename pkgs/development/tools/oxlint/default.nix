{ lib
, rustPlatform
, fetchFromGitHub
, rust-jemalloc-sys
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oxlint";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "web-infra-dev";
    repo = "oxc";
    rev = "oxlint_v${version}";
    hash = "sha256-hEN9TLIeAfMGO/PL5OcT7+H0dmoCtH+dcIEafpQ45UU=";
  };

  cargoHash = "sha256-uChoDlU0tb52pBBEqmmwhCS83pykFRpXRFSuUGquHEQ=";

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "--bin=oxlint" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Suite of high-performance tools for JavaScript and TypeScript written in Rust";
    homepage = "https://github.com/web-infra-dev/oxc";
    changelog = "https://github.com/web-infra-dev/oxc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oxlint";
  };
}
