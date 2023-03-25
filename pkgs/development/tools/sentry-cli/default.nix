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
  version = "2.15.2";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-niPQC9h/7D6nHgC+eKjY4gQwrhN0OxB5QlhKInI4LpA=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];
  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-hsVYbIfhKYAxW9hqxWJ2GrutDZGLDLR3vGhanl1PND4=";

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary ];
  };
}
