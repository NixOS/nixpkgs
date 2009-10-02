{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.6.5";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.6.5.tar.gz;
    sha256 = "1yqajk26lx817fbwpx3hfkvxzrxnr9v6l0smnm1sz7f5bdxar3f0";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
