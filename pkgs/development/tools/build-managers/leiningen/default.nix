{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, clojure, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.3.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1v83hpvp349pgqqiy4babc5m5b9lcwk0fif80fpv4jqvp0a8v6r7";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/${pname}-${version}-standalone.jar";
    sha256 = "1pqc99p4vz4q3qcs90cqql6m7kc27ihx4hbqs5alxkzk7jv8s2bk";
  };

  patches = ./lein_2.3.0.patch;

  inherit rlwrap clojure gnupg findutils coreutils jdk;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk clojure ];

  meta = {
    homepage = http://leiningen.org/;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.linux;
    maintainer = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
