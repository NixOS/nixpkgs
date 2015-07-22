{ stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "boot-${version}";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot/releases/download/${version}/boot.sh";
    sha256 = "0hvznr0z5ck32wpaqhjv2fr9365b8h0h8brnsmwijpv699l0rf1c";
  };

  inherit jdk;
  
  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jdk ];

  meta = {
    description = "Build tooling for Clojure";
    homepage = http://boot-clj.com/;
    license = stdenv.lib.licenses.epl10;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.ragge ];
  };
}
