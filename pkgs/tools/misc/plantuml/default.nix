{ stdenv, fetchurl, jre, graphviz }:

stdenv.mkDerivation rec {
  version = "7982";
  name = "plantuml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/plantuml/plantuml.${version}.jar";
    sha256 = "0hxs0whjgx36j5azdcna40rw2c7smhg0qm3kzld9vx88m0c51dgl";
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
