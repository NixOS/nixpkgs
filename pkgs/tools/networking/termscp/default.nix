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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = "termscp";
    rev = "refs/tags/v${version}";
    hash = "sha256-XK0bH5ru248tSlD3Sdxb07O6i335dfTFvxDzKdc/3GQ=";
  };

  cargoHash = "sha256-DzKxVqE0GMmpkxLH3raASgha9qGGs4kaUdSaviUwvdM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    samba
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
    Cocoa
    Foundation
    Security
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.hostPlatform.isDarwin [
    "-framework" "AppKit"
  ]);

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Feature rich terminal UI file transfer and explorer with support for SCP/SFTP/FTP/S3/SMB";
    homepage = "https://github.com/veeso/termscp";
    changelog = "https://github.com/veeso/termscp/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "termscp";
  };
}
