{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, gpgme
, libgpg-error
, libxcb
, libxkbcommon
, python3
, AppKit
, Foundation
, libiconv
, libobjc
, libresolv
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "sha256-2fTJHcJJzQIAyxLnWdoyR77tA9p/3s3UescypGwKfc0=";
  };

  cargoSha256 = "sha256-8dWMJZiWy0cO0CGAFEmtGYZ8bVK1ZR7qBkjKn6rLC+k=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
