{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.7.3";

  installPhase=''make install "PREFIX=$out"'';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.3.tar.gz;
    sha256 = "1ajgk6y9y9bng5ssdqxwpzw44pmib30vn5284rgga6vr04ppakdy";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
