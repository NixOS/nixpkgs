{ lib
, dbus
, fetchFromGitHub
, libssh
, openssl
, pkg-config
, rustPlatform
, AppKit
, Cocoa
, Foundation
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iazp3Qx2AivuL+S1Ma/64BLJtE46tc33dq5qsgw+a6Q=";
  };

  cargoSha256 = "sha256-FBW3Hl67Efnc/sNGM1LQw6msWHCYRj3KwfmSD2lpbUc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    libssh
    openssl
  ] ++ lib.optional stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
    Security
  ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-framework" "AppKit"
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
