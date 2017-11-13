{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ncdu-${version}";
  version = "1.12";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/${name}.tar.gz";
    sha256 = "16j9fyw73y1lk05a35i4q9i66laklgsx41lz5rxfr8m28x3lw3l2";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Ncurses disk usage analyzer";
    homepage = https://dev.yorhel.nl/ncdu;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
