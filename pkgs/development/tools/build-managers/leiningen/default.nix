{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.5.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1drl35313xp2gg5y52wp8414i2fm806rhgcsghl4igrm3afrv85x";
  };

  jarsrc = fetchurl {
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.jar";
    sha256 = "0fd7yqrj9asx1n3nszli7hr4fj47v2pdr9msk5g75955pw7yavp9";
  };

  patches = [ ./lein-fix-jar-path.patch ];

  inherit rlwrap gnupg findutils coreutils jdk;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk ];

  meta = {
    homepage = http://leiningen.org/;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
