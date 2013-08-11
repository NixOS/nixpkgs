{ stdenv, fetchurl, makeWrapper, jdk, rlwrap, clojure }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "18rk1rr9il5jc3103cnmii6hyc1j3k12d975sqrcqyg97h7f0jkb";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/${pname}-${version}-standalone.jar";
    sha256 = "04xmnw80f39qs2vfm5ic8bmhks1fvasiwg4snckg2zhfjkhzms05";
  };

  patches = ./lein_2.3.0.patch;

  inherit rlwrap clojure;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk clojure ];

  meta = {
    homepage = https://github.com/technomancy/leiningen;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
    maintainer = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
