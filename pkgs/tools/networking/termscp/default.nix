{ lib
, stdenv
, dbus
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, AppKit
, Cocoa
, Foundation
, Security
, samba
}:

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2EoCBz98RKynrYdcxiHySy7e07XU+loRLPaRCoVxySY=";
  };

  cargoHash = "sha256-tXTVb5ogrBrK9aMC8LZLLZazMx8pO4Xa+hociUS9mRI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    samba
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
    Security
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-framework" "AppKit"
  ]);

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "A feature rich terminal UI file transfer and explorer with support for SCP/SFTP/FTP/S3/SMB";
    homepage = "https://github.com/veeso/termscp";
    changelog = "https://github.com/veeso/termscp/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
