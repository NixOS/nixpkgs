{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, gnupg1compat }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.6.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1ndirl36gbba12cs5vw22k2zrbpqdmnpi1gciwqb1zbib2s1akg8";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "1533msarx6gb3xc2sp2nmspllnqy7anpnv9a0ifl0psxm3xph06p";
  };

  patches = [ ./lein-fix-jar-path.patch ];

  inherit rlwrap gnupg1compat findutils coreutils jdk;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk ];

  meta = {
    homepage = http://leiningen.org/;
    description = "Project automation for Clojure";
    license = stdenv.lib.licenses.epl10;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
