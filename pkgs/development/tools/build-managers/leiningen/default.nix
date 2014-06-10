{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, clojure, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.4.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0mdfp5r5qid42x7rq1cmyxqmvjdj2hk9rjz8pryf4zq3bk38m1cg";
  };

  jarsrc = fetchurl {
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.jar";
    sha256 = "099r5qcldb214c3857i7dbbqn531aahzrz39qfhqxc6f476ncdh0";
  };

  patches = [ ./lein-fix-jar-path.patch ];

  inherit rlwrap clojure gnupg findutils coreutils jdk;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk clojure ];

  meta = {
    homepage = http://leiningen.org/;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
