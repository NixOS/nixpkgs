{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ncdu-${version}";
  version = "1.10";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/${name}.tar.gz";
    sha256 = "0rqc5wpqcbfqpcwxgh3jxwa0yw2py0hv0acpsf0a9g6v9144m6gm";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "Ncurses disk usage analyzer";
    homepage = http://dev.yorhel.nl/ncdu;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
