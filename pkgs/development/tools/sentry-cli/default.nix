{ rustPlatform
, fetchFromGitHub
, lib
, openssl
, file
, rpm
, pkg-config
, stdenv
, curl
, Security
, runCommand
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
  version = "1.68.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
    sha256 = "sha256-JhKRfeAaSs4KwfcI88UbqIXNw0aZytPkIxkwrg1d2xM=";
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl file rpm ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-iV3D4ka8Sg1FMRne3A6npmZm3hFP9Qi/NdmT62BtO+8=";

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry.";
    maintainers = with maintainers; [ rizary ];
    platforms = platforms.unix;
  };
}
