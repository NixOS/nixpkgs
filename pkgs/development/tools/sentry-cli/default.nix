{ rustPlatform
, fetchFromGitHub
, lib
, openssl
, pkg-config
, stdenv
, CoreServices
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-dhIja1f+57QdgE0uYBNbgSsmFNE7h0GdcyBx4Z8bGpA=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];
  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-zLTdpbBy+41tVEItSjkHCu+D3YKiBJqlpAPMpUt5+VM=";

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ rizary loewenheim ];
  };
}
