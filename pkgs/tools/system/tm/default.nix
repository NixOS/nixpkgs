{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "tm-0.4.1";

  installPhase=''make install "PREFIX=$out"'';

  patchPhase = ''sed -i 's@/usr/bin/install@install@g' Makefile'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/tm/tm-0.4.1.tar.gz;
    sha256 = "3b389bc03b6964ad5ffa57a344b891fdbcf7c9b2604adda723a863f83657c4a0";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/tm";
    description = "terminal mixer - multiplexer for the i/o of terminal applications";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
