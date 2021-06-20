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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "sha256-PLKBkOwhp8Os2yAx+nzfWs41d3v12nnUVFB6oDfl00Y=";
  };

  cargoSha256 = "sha256-lHrA4TlaOcMhO2a8lnd8hc6X2cDnWKMNLWEzlezIcNE=";

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
