{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, clojure, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.4.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1qdq3v7wv9jacw4bipgx24knlipw6zdcx43yd1qyw6zwaad51ckw";
  };

  jarsrc = fetchurl {
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.jar";
    sha256 = "0n4kpmzw9nvppq758lhnrr7xps5j6gwmdm98m772cj7j4vixsrzb";
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
