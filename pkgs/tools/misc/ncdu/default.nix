{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ncdu-${version}";
  version = "1.13";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${name}.tar.gz";
    sha256 = "0ni56ymlii577src4dzfbrq1mznbf6i0nka4bvh2sb1971f2ingl";
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
