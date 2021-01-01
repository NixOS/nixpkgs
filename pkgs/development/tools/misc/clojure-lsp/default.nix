{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20201228T020543";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/release-${version}/${pname}.jar";
    sha256 = "0jkpw7dx7976p63c08bp43fiwk6f2h2nxj9vv1zr103hgywpplri";
  };

  dontUnpack = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm644 $src $out/share/java/${pname}.jar
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}.jar" \
      --add-flags "-Xmx2g" \
      --add-flags "-server"
  '';

  meta = with stdenv.lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/snoe/clojure-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };
}
