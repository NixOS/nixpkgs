{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    hash = "sha256-VD10BO7bxTmD1A1AZsiEiYBsVhAKlXxdHNMmXqpvpKM=";
  };

  cargoHash = "sha256-7MK0iLBpjvWE7UH5Tb3qIm2XnEVsAvBy34Ed4wHagZQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda siraben ];
    mainProgram = "jaq";
  };
}
