{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-E/QslRDeifFHlHUELv9rYHjfCAB1yXXiXlWOyPNkfps=";
  };

  cargoHash = "sha256-7TTHBeZ68G6k5eHBL1zDGsYiTyx27fBbN7Rl9AiZTng=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Chat with gpt-3.5/chatgpt in terminal.";
    homepage = "https://github.com/sigoden/aichat";
    license = licenses.mit;
    maintainers = with maintainers; [ mwdomino ];
  };
}
