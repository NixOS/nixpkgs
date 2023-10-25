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
}:

rustPlatform.buildRustPackage rec {
  pname = "termscp";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bQvoTy48eYK369Ei6B8l6F5/pfQGYiHdz3KsQV7Bi9Y=";
  };

  cargoHash = "sha256-/nadstDHzLOrimL+xK7/ldOozz7ZS1nRQmkIhGHK8p8=";

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

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-framework" "AppKit"
  ]);

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Terminal tool for file transfer and explorer";
    homepage = "https://github.com/veeso/termscp";
    changelog = "https://github.com/veeso/termscp/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
