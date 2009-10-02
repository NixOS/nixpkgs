{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.6.4";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.6.4.tar.gz;
    sha256 = "caf3e912c150dacc4a182e919ed3eabc1294c5e4e1de333e85d06eea2c0136e3";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
