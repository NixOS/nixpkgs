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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7T3VmcI9CWrKROQ0U2du2d8e0A6XnOxpd8Zl0T4w+KQ=";
  };

  cargoSha256 = "sha256-WuoN7b9Fw2Op8tck4ek8gyufInlbPkDHHtLAsbG1NLE=";

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
