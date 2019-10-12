{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.14.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "0gp1aszzrh8b6fhv8fspvkmr0qwc55z6z4w6l7r8j09sq7lf0cdy";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = https://dev.yorhel.nl/ncdu;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
