{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "14p7lpdp85ay5p2r9npm2adp9njcssi47mb1fh2iyn8lp51d22bi";
  };

  cargoSha256 = "07h8d8fm20dp9xcz9vic63xnx2rbvanf2ivks1jiv32iy0kgz74p";

  meta = with stdenv.lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ filalex77 ];
  };
}
