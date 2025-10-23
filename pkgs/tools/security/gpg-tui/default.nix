{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gpgme,
  libgpg-error,
  pkg-config,
  python3,
  libiconv,
  libresolv,
  x11Support ? true,
  libxcb,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    hash = "sha256-qGm0eHpVFGn8tNdEnmQ4oIfjCxyixMFYdxih7pHvGH0=";
  };

  cargoHash = "sha256-XdT/6N7CJJ8LY0KmkO6PuRdnq1FZvbZrGhky1hmyr2Y=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
    pkg-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpg-error
  ]
  ++ lib.optionals x11Support [
    libxcb
    libxkbcommon
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
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
