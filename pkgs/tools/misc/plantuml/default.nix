{ stdenv, fetchurl, jre, graphviz }:

stdenv.mkDerivation rec {
  version = "7991";
  name = "plantuml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/plantuml/plantuml.${version}.jar";
    sha256 = "0afhgiq2165ahj8ww0pmk69nqgpibllp9nhpk8wapg3zknh2hx5r";
  };

  # It's only a .jar file and a shell wrapper
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp "$src" "$out/lib/plantuml.jar"

    cat > "$out/bin/plantuml" << EOF
    #!${stdenv.shell}
    export GRAPHVIZ_DOT="${graphviz}/bin/dot"
    exec "${jre}/bin/java" -jar "$out/lib/plantuml.jar" "\$@"
    EOF
    chmod a+x "$out/bin/plantuml"
  '';

  meta = with stdenv.lib; {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = http://plantuml.sourceforge.net/;
    # "java -jar plantuml.jar -license" says GPLv3 or later
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
