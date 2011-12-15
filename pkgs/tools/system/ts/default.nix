{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.7.2";

  installPhase=''make install "PREFIX=$out"'';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.2.tar.gz;
    sha256 = "08f9ipg98d6ygzb4fzdm1z157llzh4akipmq14ycfd7l023vidik";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
