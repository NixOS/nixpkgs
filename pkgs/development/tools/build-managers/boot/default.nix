{ stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  version = "2.5.2";
  name = "boot-${version}";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot-bin/releases/download/${version}/boot.sh";
    sha256 = "0brsimvmmpksxwc4l5c0x0cl5hhdjz76crd26yxphjvzyf7fypc9";
  };

  inherit jdk;
  
  builder = ./builder.sh;

  propagatedBuildInputs = [ jdk ];

  meta = {
    description = "Build tooling for Clojure";
    homepage = http://boot-clj.com/;
    license = stdenv.lib.licenses.epl10;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.ragge ];
  };
}
