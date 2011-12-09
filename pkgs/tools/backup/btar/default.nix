{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-0.9";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "0w5cliw1n7syg67pqgljmi1f86w383ccw57h8p5h7cgsnabsbnq3";
  };

  buildInputs = [ librsync ];

  installPhase = "make install PREFIX=$out";

  meta = {
    description = "Tar-compatible block-based archiver";
    license = "GPLv3+";
    homepage = http://viric.name/cgi-bin/btar;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
