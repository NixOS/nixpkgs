{stdenv, fetchurl, openjdk}:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "1.7.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/1.7.0/bin/lein-pkg";
    sha256 = "1339f6ffc7bae3171174fc9eae990f5b9710ff2804038e931d531632c57f189c";
  };

  jarsrc = fetchurl {
    url = "https://github.com/downloads/technomancy/leiningen/leiningen-1.7.0-standalone.jar";
    sha256 = "501eaa1c2a19ca4ffc2fde1776552cb513d69ee874abb547c40cee92156e50bf";
  };

  clojuresrc = fetchurl {
    url = "http://build.clojure.org/releases/org/clojure/clojure/1.2.1/clojure-1.2.1.jar";
    sha256 = "b38853254a2df9138b2e2c12be0dca3600fa7e2a951fed05fc3ba2d9141a3fb0";
  };

  patches = [ ./lein.patch ];

  builder = ./builder.sh;

  propagatedBuildInputs = [ openjdk ];

  meta = {
    homepage = https://github.com/technomancy/leiningen;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
  };
}
