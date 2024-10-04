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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = "termscp";
    rev = "refs/tags/v${version}";
    hash = "sha256-/WYhwt/GAULX/UY1GyqzauaMRlVuvAwwS0DNfYB7aD4=";
  };

  cargoHash = "sha256-OqrJpVb9EF22OGP5SOIfEUg66+T96qcN3GH+fs72+7A=";

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
