{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "krill";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gMGDZI8uk5E7C2+zGPzn1wz39NUJ4tVExwwvc4Y2wDM=";
  };

  cargoSha256 = "sha256-vtEobZvOsI18cqExR++DUNEI7J+h9ek1Lc+Q4Db8OrQ=";

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "RPKI Certificate Authority and Publication Server written in Rust";
    longDescription = ''
      Krill is a free, open source RPKI Certificate Authority that lets you run
      delegated RPKI under one or multiple Regional Internet Registries (RIRs).
      Through its built-in publication server, Krill can publish Route Origin
      Authorisations (ROAs) on your own servers or with a third party.
    '';
    homepage = "https://github.com/NLnetLabs/krill";
    changelog = "https://github.com/NLnetLabs/krill/blob/v${version}/Changelog.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ steamwalker ];
  };
}
