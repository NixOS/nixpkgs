{stdenv, fetchurl, makeWrapper, openjdk, rlwrap, clojure }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "07asjk1pr47mgzf8m1igci9zhik49ycijhliq1mw001n9qqxlf74";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/leiningen-${version}-standalone.jar";
    sha256 = "1rzvkc0v66gxv6i5x4w7dn6bvd0dxylsvy7fhp84k9rd7cikk89j";
  };

  patches = ./lein_2.1.1.patch;

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
