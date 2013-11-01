{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ncdu-${version}";
  version = "1.8";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/${name}.tar.gz";
    sha256 = "42aaf0418c05e725b39b220166a9c604a9c54c0fbf7692c9c119b36d0ed5d099";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "Ncurses disk usage analyzer";
    homepage = http://dev.yorhel.nl/ncdu;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
