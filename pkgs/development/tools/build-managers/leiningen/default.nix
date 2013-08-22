{ stdenv, fetchurl, makeWrapper, jdk, rlwrap, clojure }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.3.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "07z4sr4ssi9lqr1kydxn4gp992n44jsr6llarlvpx0ns8yi4gx0l";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/${pname}-${version}-standalone.jar";
    sha256 = "00hmxyvrzxjwa2qz3flnrvg2k2llzvprk9b5szyrh3rv5z5jd4hw";
  };

  patches = ./lein_2.3.0.patch;

  inherit rlwrap clojure;

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
