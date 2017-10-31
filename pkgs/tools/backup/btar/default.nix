{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-1.1.1";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "0miklk4bqblpyzh1bni4x6lqn88fa8fjn15x1k1n8bxkx60nlymd";
  };

  buildInputs = [ librsync ];

  installPhase = "make install PREFIX=$out";

  meta = {
    description = "Tar-compatible block-based archiver";
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = http://viric.name/cgi-bin/btar;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
