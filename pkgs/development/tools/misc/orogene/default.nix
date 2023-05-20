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
  version = "0.3.26";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    rev = "v${version}";
    hash = "sha256-9Rq2/o2W0l2/JR/D95+2AjpVzdZuDVDyQFFNb5Us/hg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-X7DWJ/3Zqtjgw2s/H+dG8tu8f7/aZVIliloJe2Uz9RE=";

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
