{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.6.6";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.6.6.tar.gz;
    sha256 = "0mdg123ppq8ibf4315l4qi0w3n7wlj4x8dq5gx8f680v4bjvc30g";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
    description = "task spooler - batch queue";
    license="GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
