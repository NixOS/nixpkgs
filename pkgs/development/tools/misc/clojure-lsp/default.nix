{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.02.05-15.32.53";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/${pname}.jar";
    hash = "sha256-kKjgAO3DEpZOm91Tzkhj4rmNOaacZi74o/qfp8n11Z4=";
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
