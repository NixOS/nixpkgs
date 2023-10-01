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
  version = "0.3.32";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    rev = "v${version}";
    hash = "sha256-UB/FI5LUyksKzAgzsza5NTDtYWou69hqj0M2GWV/FcA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-/Yb1QTsye60qL6B3TM6Wd1W8n4XMxMhu42CLvJcqIYw=";

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
