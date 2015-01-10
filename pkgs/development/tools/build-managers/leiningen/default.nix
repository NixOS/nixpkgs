{ stdenv, fetchurl, makeWrapper
, coreutils, findutils, jdk, rlwrap, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.5.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0pqqb2bh0a17426diwyhk5vbxcfz45rppbxmjydsmai94jm3cgix";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "1irl3w66xq1xbbs4g10dnw1vknfw8al70nhr744gfn2za27w0xdl";
  };

  patches = [ ./lein-fix-jar-path.patch ];

  inherit rlwrap gnupg findutils coreutils jdk;

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
