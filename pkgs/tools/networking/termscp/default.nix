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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fVZDpzgcpMWOoUtoq7go/NFWfoR1aONuRtTba0sqPZk=";
  };

  cargoSha256 = "sha256-iLm73dWF9z/obtAXe5dZlvJcxU6hB5N0vaSc/HLuTuQ=";

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
