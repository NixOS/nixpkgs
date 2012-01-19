{stdenv, fetchurl, openjdk}:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "1.6.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/stable/bin/lein-pkg";
    sha256 = "e177a493ed0c4a7874f1391d5cc72cc1e541e55ed3d6e075feec87b5da6f8277";
  };

  jarsrc = fetchurl {
    url = "https://github.com/downloads/technomancy/leiningen/leiningen-1.6.2-standalone.jar";
    sha256 = "e35272556ece82d9a6a54b86266626da1b5f990ff556639dd7dd1025d6ed4226";
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