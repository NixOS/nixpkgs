{ stdenv, fetchurl, pkgconfig, ncurses }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "robotfindskitten-${version}";
  version = "2.7182818.701";

  src = fetchurl {
    url = "mirror://sourceforge/project/rfk/robotfindskitten-POSIX/mayan_apocalypse_edition/${name}.tar.gz";
    sha256 = "06fp6b4li50mzw83j3pkzqspm6dpgxgxw03b60xkxlkgg5qa6jbp";
  };

  buildInputs = 
  [ pkgconfig ncurses ];

  meta = {
    description = "Yet another zen simulation; A simple find-the-kitten game";
    homepage = http://robotfindskitten.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
