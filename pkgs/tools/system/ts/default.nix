{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.6.3";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.6.3.tar.gz;
    sha256 = "70d9dd20e8f7cb45336c9eee048d47ff3c6cd3fdd2b36c88035c460515e7004f";
  };

  meta = { homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
           description = "task spooler - batch queue";
           license="GPLv2";
         };
}
