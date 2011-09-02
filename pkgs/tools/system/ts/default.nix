{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.7.0";

  installPhase=''make install "PREFIX=$out"'';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.0.tar.gz;
    sha256 = "1m9nf0299idkh355afk2c9v9qqpxm4ram3gyf8a9qv4f9gg6hprp";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
