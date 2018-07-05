{ wrapCommand, lib, fetchurl, jre, graphviz }:

let
  jar = fetchurl {
    url = "mirror://sourceforge/project/plantuml/${version}/plantuml.${version}.jar";
    sha256 = "0ssfg6lpk41ydhxhi6y6c9ca3hpql6gg3bxjws8vrx9s3s6r5rb0";
  };
  version = "1.2017.18";
in wrapCommand "plantuml" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = [ "--add-flags -jar" "--add-flags $jar"
                      "--set GRAPHVIZ_DOT ${graphviz}/bin/dot"];
  meta = with lib; {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = http://plantuml.sourceforge.net/;
    # "java -jar plantuml.jar -license" says GPLv3 or later
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.unix;
  };
}
