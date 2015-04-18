{ stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  version = "2.0.0-rc8";
  name = "boot-${version}";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot/releases/download/${version}/boot.sh";
    sha256 = "1jqj04f33prb6nqsv7mffwdnz47ppi3szsbdzphjx8xzz394nl7j";
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
