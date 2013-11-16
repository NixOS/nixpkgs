{ stdenv, fetchurl, makeWrapper, jdk, rlwrap, clojure, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.3.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0lc5ivgknkflk6k4a4q1r8bm3kq63p4cazfs1rdb02cfhdip52hc";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/${pname}-${version}-standalone.jar";
    sha256 = "1a8i0940ww7xqhwlaaavsgw8s9rjqdnv46hfsla41ns789bappxf";
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
    platforms = stdenv.lib.platforms.linux;
    maintainer = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
