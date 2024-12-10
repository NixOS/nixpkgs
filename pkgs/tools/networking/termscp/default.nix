{
  lib,
  stdenv,
  dbus,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  AppKit,
  Cocoa,
  Foundation,
  Security,
  samba,
}:

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = "termscp";
    rev = "refs/tags/v${version}";
    hash = "sha256-/Mnoljgp87ML6+3vV1vZTFO0TSY5hr8E8U1fXJq31pE=";
  };

  cargoHash = "sha256-xq21cncEYNSwDiKvVSM1J2Jz3TqOkYMK3gckKpM5+6E=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      dbus
      openssl
      samba
    ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
      Cocoa
      Foundation
      Security
    ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [
      "-framework"
      "AppKit"
    ]
  );

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "A feature rich terminal UI file transfer and explorer with support for SCP/SFTP/FTP/S3/SMB";
    homepage = "https://github.com/veeso/termscp";
    changelog = "https://github.com/veeso/termscp/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "termscp";
  };
}
