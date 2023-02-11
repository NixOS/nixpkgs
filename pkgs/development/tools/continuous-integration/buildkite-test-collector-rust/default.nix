{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "buildkite-test-collector-rust";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "test-collector-rust";
    rev = "v${version}";
    sha256 = "sha256-rY/+AwxO0+xcnRj0A8TRhCUJQ0ecosybI6It1mDOdQM=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoSha256 = "sha256-qfJ0ROi0S0mmPl6kKrW3dp3VLjYqK+sBVj+iKDNTjyM=";

  meta = with lib; {
    description = "Rust adapter for Buildkite Test Analytics";
    homepage = "https://buildkite.com/test-analytics";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jfroche ];
  };
}
