{stdenv, fetchurl, makeWrapper, openjdk, rlwrap, clojure }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1k1d1dr11jmm166r12wkw6j4wnlxk3p7wkvlk3cxhdrmyacqfrzk";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/leiningen-${version}-standalone.jar";
    sha256 = "0y1llnbsgimxg3zpy070j98k1i6y1r0asn4h8aal0db8x3sj49j2";
  };

  patches = ./lein_2.1.0.patch;

  inherit rlwrap clojure;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ openjdk clojure ];

  meta = {
    homepage = https://github.com/technomancy/leiningen;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
  };
}
