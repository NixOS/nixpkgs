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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "sha256-ajzx54uQFNZraDwqEKG9sdlMquJnluiaCqsR+JT79jw=";
  };

  cargoSha256 = "sha256-UjrX+Z8slMBAiKhiFjxSoX74vIiFW9bMww49oPa18ag=";

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
