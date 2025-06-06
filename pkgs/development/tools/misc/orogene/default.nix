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
  version = "0.3.34";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    rev = "v${version}";
    hash = "sha256-GMWrlvZZ2xlcvcRG3u8jS8KiewHpyX0brNe4pmCpHbM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-I9uh8jV1hH5R/UHM3mz2/ZA7QY4O9gW5qXlVSfao0ZM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  preCheck = ''
    export CI=true
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Package manager for tools that use node_modules";
    homepage = "https://github.com/orogene/orogene";
    changelog = "https://github.com/orogene/orogene/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 isc ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oro";
  };
}
