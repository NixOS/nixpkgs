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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "veeso";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+5ljnCVbaiqqfXCJjMMInoLjLmZjCIoDkQi9pS6VKpc=";
  };

  cargoHash = "sha256-GoWVDU1XVjbzZlGPEuHucnxcvhf4Rqx/nSEVygD9gCo=";

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
