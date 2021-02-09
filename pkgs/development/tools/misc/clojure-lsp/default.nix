{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.02.07-22.51.26";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/${pname}.jar";
    sha256 = "sha256-6EiWyoH7voRjjDNWnWkyBV2eOPuoabRE7Os/JRE/LUk=";
  };

  dontUnpack = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm644 $src $out/share/java/${pname}.jar
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-Xmx2g" \
      --add-flags "-server" \
      --add-flags "-jar $out/share/java/${pname}.jar"
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/snoe/clojure-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };
}
