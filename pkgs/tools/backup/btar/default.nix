{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-1.0.0";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "141mqrghqmms6zpbwn9bw98q4rkxfyly950jh8hajq9d2fk5qyn1";
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
