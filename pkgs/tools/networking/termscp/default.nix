{ lib
, dbus
, fetchFromGitHub
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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AyDENQj73HzNh1moO/KJl7OG80w65XiYmIl8d9/iAtE=";
  };

  cargoHash = "sha256-NgBQvWtwkAvp0V7zWGw+lNAcVqqDMAeNC0KNIBrwjEE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
    Security
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

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
