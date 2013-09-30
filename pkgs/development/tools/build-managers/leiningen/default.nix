{ stdenv, fetchurl, makeWrapper, jdk, rlwrap, clojure, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.3.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1dpvs6b2n309ixglmdpw64k8fbz8n4rd61xp4jrih0z7dgvcql6h";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/${pname}-${version}-standalone.jar";
    sha256 = "0g6sgmgl0azawwchi86qxqsknk753ffwiszsxg4idqb713ac6cda";
  };

  patches = ./lein_2.3.0.patch;

  inherit rlwrap clojure gnupg;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk clojure ];

  meta = {
    homepage = http://leiningen.org/;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
    maintainer = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
