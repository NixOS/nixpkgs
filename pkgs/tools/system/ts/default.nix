{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.6";

  installPhase=''make install "PREFIX=$out"'';

  patchPhase = ''sed -i 's@/usr/bin/install@install@g' Makefile; set -x'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.6.tar.gz;
    sha256 = "663df09f9a6e6491f7924b1cdf8a5d00546c736ec3f5f1135ccccb83bf4f2ce8";
  };

  meta = { homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
           description = "task spooler - batch queue";
           license="GPLv2";
         };
}
