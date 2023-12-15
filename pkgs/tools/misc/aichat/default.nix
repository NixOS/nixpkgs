{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-KY8GUUPZyb89b9mGd+EuYP8M7bKxt7oKQfaaX1R4BTE=";
  };

  cargoHash = "sha256-YTLiJ8/aTN3d2xkEqtiyP47KeDK88I2Raix8kmddDNE=";

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
    mainProgram = "aichat";
  };
}
