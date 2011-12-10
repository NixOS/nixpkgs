{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-0.9.1";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "1fmaq5z81zvs3gjrkwnqz8nb4a6dqij5cmw99jhcaxlnwl45y3vj";
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
