{ stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  version = "2.4.2";
  name = "boot-${version}";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot/releases/download/${version}/boot.sh";
    sha256 = "8c045823c042e612d140528b4be136fcfa8bf1f1df390906bffcee6df46ca7a1";
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
