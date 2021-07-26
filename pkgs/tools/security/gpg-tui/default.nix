{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, gpgme
, libgpgerror
, libxcb
, python3
, AppKit
, Foundation
, libiconv
, libobjc
, libresolv
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "sha256-ti49b03Ta/MVDNIzW1WhWxJqHNVW9EALUcbElcZvurQ=";
  };

  cargoSha256 = "sha256-jF1Ozo5q5cKG9KjR1scbCCofG3FT3Fv98Cj0iOl18+c=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpgerror # for gpg-error-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpgerror
    libxcb
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
