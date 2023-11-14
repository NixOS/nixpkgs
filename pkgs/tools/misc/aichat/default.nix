{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-51mdUtCawXU/gSN+OGzgyzYyqa5onLDsEi5FIIa/GFk=";
  };

  cargoHash = "sha256-dRanZt4R1welqp+U/714rOU++/nSs60ZBSeiYimBNZA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "Chat with gpt-3.5/chatgpt in terminal.";
    homepage = "https://github.com/sigoden/aichat";
    license = licenses.mit;
    maintainers = with maintainers; [ mwdomino ];
  };
}
