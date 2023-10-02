{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "23.9.1";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "cargo-mutants-${version}";
    hash = "sha256-VFlnCzaWy8IDuCkr1aHKhJThS3Sde9I2mRj8hKKdXOk=";
  };

  cargoHash = "sha256-C7ikZZrTw+KjY+kjgEZGZ7lC8irLw+uXl+T+6Grq7UY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A mutation testing tool for Rust";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
