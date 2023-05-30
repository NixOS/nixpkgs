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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    hash = "sha256-vzdQqiAguwXZ3QNlctnfsuFxNYwBLICVqonFKXdMvSQ=";
  };

  cargoHash = "sha256-clxpTayrWSu0esu8L4/Kf8oKk8zAK3XJwT8IJqHoZpw=";

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
    maintainers = with maintainers; [ dotlambda ];
  };
}
