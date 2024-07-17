{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gpgme,
  libgpg-error,
  pkg-config,
  python3,
  AppKit,
  Foundation,
  libiconv,
  libobjc,
  libresolv,
  x11Support ? true,
  libxcb,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    hash = "sha256-aHmLcWiDy5GMbcKi285tfBggNmGkpVAoZMm4dt8LKak=";
  };

  cargoHash = "sha256-rtBvo2nX4A6K/TBl6xhW8huLXdR6xDUhzMB3KRXRYMs=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
    pkg-config
    python3
  ];

  buildInputs =
    [
      gpgme
      libgpg-error
    ]
    ++ lib.optionals x11Support [
      libxcb
      libxkbcommon
    ]
    ++ lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [
      dotlambda
      matthiasbeyer
    ];
    mainProgram = "gpg-tui";
  };
}
