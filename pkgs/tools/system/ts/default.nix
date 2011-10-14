{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.7.1";

  installPhase=''make install "PREFIX=$out"'';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.1.tar.gz;
    sha256 = "0s1hrgw99jn6ar01lcvhdgqsw0jzfnbpdayp0pydr6ikx1zwz70v";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
