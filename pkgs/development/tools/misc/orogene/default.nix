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
  version = "0.3.31";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    rev = "v${version}";
    hash = "sha256-q6YPyxfOiTOQ6eVjBIsnV7HhwM3A3EIiRCJpDGKZRrQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-2NAwy95C8/rEq5ssq3poBOL+crwaHJh1Vo+sYiDb6Ds=";

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
