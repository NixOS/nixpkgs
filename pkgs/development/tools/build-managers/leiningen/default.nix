{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, gnupg1compat }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.5.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0xbfg6v6f3qyi99dbqragh3za2a0agrcq9c0qbkshvp5yd0fx4h1";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "1p93j03v02mf1cnli6lv9qqnx7gwxr571g8z7y06p0d4nq31c32b";
  };

  patches = [ ./lein-fix-jar-path.patch ];

  inherit rlwrap gnupg1compat findutils coreutils jdk;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk ];

  meta = {
    homepage = http://leiningen.org/;
    description = "Project automation for Clojure";
    license = stdenv.lib.licenses.epl10;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
