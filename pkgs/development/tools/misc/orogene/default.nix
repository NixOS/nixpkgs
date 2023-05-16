{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "orogene";
  version = "0.3.25";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    rev = "v${version}";
    hash = "sha256-QQhlkTg14nPYQvKYoZf07PjknTZZRUTzBzNFJeovny8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-uxW196f/PEVxGHmZ7hUyvaIz1OD1XmyVEuwk8Hdvsvs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  preCheck = ''
    export CI=true
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A package manager for tools that use node_modules";
    homepage = "https://github.com/orogene/orogene";
    changelog = "https://github.com/orogene/orogene/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 isc ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oro";
  };
}
