{stdenv, fetchurl, makeWrapper, openjdk, rlwrap}:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "1.7.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "7684b899edd6004abafd8e26d2b43d5691217f1aaca535fb94bde1594c8129a5";
  };

  jarsrc = fetchurl {
    url = "https://github.com/downloads/technomancy/leiningen/leiningen-${version}-standalone.jar";
    sha256 = "5d167b7572b9652d44c2b58a13829704842d976fd2236530ef552194e6c12150";
  };

  clojuresrc = fetchurl {
    url = "http://build.clojure.org/releases/org/clojure/clojure/1.2.1/clojure-1.2.1.jar";
    sha256 = "b38853254a2df9138b2e2c12be0dca3600fa7e2a951fed05fc3ba2d9141a3fb0";
  };

  patches = [ ./lein-rlwrap.patch ./lein.patch ];

  inherit rlwrap;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ openjdk ];

  meta = {
    homepage = https://github.com/technomancy/leiningen;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
  };
}
