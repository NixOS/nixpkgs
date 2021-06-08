{ rustPlatform
, fetchFromGitHub
, lib
, openssl
, pkg-config
, stdenv
, curl
, Security
, runCommand
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "1.66.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-ivQBn5GGb64Jq0gpywAg20309QQMpasg/Bu5sHKj02Y=";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-xS88KZWYkg3v8TJZUVVgQhR++CrZGD0DQnLPktSUJQk=";

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry.";
    maintainers = with maintainers; [ rizary ];
    platforms = platforms.unix;
  };
}
