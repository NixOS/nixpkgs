{ stdenv, fetchurl, jre, graphviz }:

stdenv.mkDerivation rec {
  version = "8047";
  name = "plantuml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/plantuml/plantuml.${version}.jar";
    sha256 = "11a1qchalymvc7qn9kqxamp8qm8fljpnxmfi4zs8sg75nzddjnlm";
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
