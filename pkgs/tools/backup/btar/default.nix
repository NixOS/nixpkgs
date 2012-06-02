{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-1.0.0";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "0k06zgwccxhzh4y99cxiwr7zylr5cwzf2dgx8bvx0gbb03r6gh9l";
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
