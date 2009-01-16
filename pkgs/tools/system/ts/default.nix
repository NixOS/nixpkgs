{stdenv, fetchurl}:

stdenv.mkDerivation {

  name = "ts-0.6.2";

  installPhase=''make install "PREFIX=$out"'';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.6.2.tar.gz;
    sha256 = "6a99b48800658fb7424a76c5756a638a6b6abb2a8a8c129e196bc24a9aeeb5cc";
  };

  meta = { homepage = "http://vicerveza.homeunix.net/~viric/soft/ts";
           description = "task spooler - batch queue";
           license="GPLv2";
         };
}
