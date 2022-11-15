{ rustPlatform
, fetchFromGitHub
, lib
, openssl
, pkg-config
, stdenv
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-91nrxCqX4BJVP9gKcrWrEgjVkTnwkVKxFA8KjcFjaOs=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-nWhqYvji53KurLGECsgE13Bwxng8CZUfdkv3mhHSl7Y=";

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary ];
  };
}
