{ stdenv, fetchFromGitHub, diffutils, gd, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "s2png";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "s2png";
    rev = "v${version}";
    sha256 = "0y3crfm0jqprgxamlly713cka2x1bp6z63p1lw9wh4wc37kpira6";
  };

  buildInputs = [ diffutils gd pkgconfig ];
  installFlags = [ "prefix=" "DESTDIR=$(out)" ];

  meta = {
    homepage = "https://github.com/dbohdan/s2png/";
    description = "Store any data in PNG images";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.dbohdan ];
    platforms = stdenv.lib.platforms.unix;
  };
}
