{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, gpgme
, libgpg-error
, libxcb
, libxkbcommon
, pkg-config
, python3
, AppKit
, Foundation
, libiconv
, libobjc
, libresolv
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    hash = "sha256-zTFWIIqIDMI77lg2CB1ug+GeKPVIT1OQ1p80x6tLgGg=";
  };

  cargoHash = "sha256-5qLrmU/SfUfiQOOpECTEn8K142STnbhqE3XbJFxKPZg=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
    pkg-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpg-error
    libxcb
    libxkbcommon
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Foundation
    libiconv
    libobjc
    libresolv
  ];

  meta = with lib; {
    description = "Terminal user interface for GnuPG";
    homepage = "https://github.com/orhun/gpg-tui";
    changelog = "https://github.com/orhun/gpg-tui/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda matthiasbeyer ];
  };
}
