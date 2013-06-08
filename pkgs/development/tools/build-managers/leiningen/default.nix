{stdenv, fetchurl, makeWrapper, openjdk, rlwrap, clojure }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.1.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "10s4xpwrhd8wz3h2vj8ay4rf2hw8vzswfkr8ckckk3fhjcn130dy";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/${pname}-${version}-standalone.jar";
    sha256 = "08jq21zpsgwsmsz7lpfxidj2s3mv8i23fjwyl9qc6dngskkx45sa";
  };

  patches = ./lein_2.1.2.patch;

  inherit rlwrap clojure;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ openjdk clojure ];

  meta = {
    homepage = https://github.com/technomancy/leiningen;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
    maintainer = with stdenv.lib.maintainers; [the-kenny];
  };
}
