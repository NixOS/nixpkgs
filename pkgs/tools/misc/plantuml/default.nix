{ stdenv, fetchurl, makeWrapper, jre, graphviz }:

stdenv.mkDerivation rec {
  version = "1.2019.7";
  name = "plantuml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/plantuml/${version}/plantuml.${version}.jar";
    sha256 = "1md8dyjlvwfg4hbvigcvzipj1gf8hb39rqqh825aa2swchs8nvhm";
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

  meta = with stdenv.lib; {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = http://plantuml.sourceforge.net/;
    # "plantuml -license" says GPLv3 or later
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
