{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-1.1";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "17vkccv2b7mz1pj5zmnapjkx9aykzb6xf5wibwhn8da6kn7qwnnj";
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
