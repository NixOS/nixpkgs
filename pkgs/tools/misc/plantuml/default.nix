{ lib, stdenv, fetchurl, makeWrapper, jre, graphviz }:

stdenv.mkDerivation rec {
  version = "1.2022.6";
  pname = "plantuml";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml/releases/download/v${version}/plantuml-pdf-${version}.jar";
    sha256 = "sha256-J3EfNwDYQ2CO5qWH37wMKtdLStGjHu75wfEMX5Y2NeE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm644 $src $out/lib/plantuml.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/plantuml \
      --argv0 plantuml \
      --set GRAPHVIZ_DOT ${graphviz}/bin/dot \
      --add-flags "-jar $out/lib/plantuml.jar"

    $out/bin/plantuml -help
  '';

  meta = with lib; {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = "http://plantuml.sourceforge.net/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    # "plantuml -license" says GPLv3 or later
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor Mogria ];
    platforms = platforms.unix;
  };
}
