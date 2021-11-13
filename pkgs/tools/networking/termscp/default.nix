{ lib
, dbus
, fetchFromGitHub
, libssh
, openssl
, pkg-config
, rustPlatform
, Foundation
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "v${version}";
    sha256 = "131kij6pnw9r0p2a28g00z85dh758h4rm9ic09qmp61cq7dphkc1";
  };

  cargoSha256 = "1k2vwmfy6dczgs3bz8k4j24cc8l7l9fdh3ymp79ril4rp1v6kfp2";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    libssh
    openssl
  ] ++ lib.optional stdenv.isDarwin [
    Foundation
    Security
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Terminal tool for file transfer and explorer";
    homepage = "https://github.com/veeso/termscp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
