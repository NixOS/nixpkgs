{ lib
, mdbook
, nodePackages
, python3
, util-linux
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-cmdrun";
  version = "0.6.0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "FauconFan";
    repo = pname;
    rev = "d1fef67f100563c2a433b1f5dd5a71810db6b90d";
    hash = "sha256-Q2h64XCyDxLmmCNC3wTw81pBotaMEUjY5y0Oq6q20cQ=";
  };

  nativeCheckInputs = [
    mdbook # used by tests/book.rs
    nodePackages.nodejs # used by tests/regression/inline_call/input.md
    python3 # used by tests/regression/py_*
    util-linux # used by tests/regression/shell/input.md
  ];

  cargoHash = "sha256-gT3DyQRJWn1HuR6fXeqk8aUPb+jmC+V1McdDN2JGXuI=";

  meta = with lib; {
    description = "mdbook preprocessor to run arbitrary commands";
    mainProgram = "mdbook-cmdrun";
    homepage = "https://github.com/FauconFan/mdbook-cmdrun";
    license = licenses.mit;
    maintainers = with maintainers; [ pinpox matthiasbeyer ];
  };
}
