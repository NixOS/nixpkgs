{ lib
, rustPlatform
, fetchFromGitHub
, gpgme
, libgpgerror
, libxcb
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "sha256-D3H1tJ+7ObNssrc/eMzYQPxeA8cOpGgRF/5VX2kfha0=";
  };

  cargoSha256 = "sha256-0NctI16ZsOAEkuCRQ45aOl4p2a3N6Nx88HwtbWht/UY=";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpgerror # for gpg-error-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpgerror
    libxcb
  ];

  meta = with lib; {
    description = "Terminal user interface for GnuPG";
    homepage = "https://github.com/orhun/gpg-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
