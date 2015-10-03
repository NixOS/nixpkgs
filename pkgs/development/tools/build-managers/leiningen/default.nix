{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, gnupg1compat }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.5.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0pzs645315nvn981w3nj8fi30g6kq67cmj7hq7da658qlk0p6r7i";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "0qhvgvii4x3p49bx494f6fc7dfvxx2crp2wbkldxx2brvh105iv4";
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
