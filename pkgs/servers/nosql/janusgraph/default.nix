{ stdenv
, janusgraph-unwrapped
, makeWrapper
, jdk
}:

stdenv.mkDerivation {
  pname = "janusgraph";
  inherit (janusgraph-unwrapped) version meta;

  src = janusgraph-unwrapped;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/janusgraph
    cp -r $src/conf $src/scripts $src/lib $out/share/janusgraph

    # Adapted from janusgraph-unwrapped.out/bin/janusgraph-server.sh
    JANUSGRAPH_LIB=$out/share/janusgraph/lib
    classpath=""
    # Add the slf4j-log4j12 binding
    classpath="$classpath":$(find -L $JANUSGRAPH_LIB -name 'slf4j-log4j12*.jar' | sort | tr '\n' ':')
    # Add the jars in $JANUSGRAPH_LIB that start with "janusgraph"
    classpath="$classpath":$(find -L $JANUSGRAPH_LIB -name 'janusgraph*.jar' | sort | tr '\n' ':')
    # Add the remaining jars in $JANUSGRAPH_LIB.
    classpath="$classpath":$(find -L $JANUSGRAPH_LIB -name '*.jar' \
                    \! -name 'janusgraph*' \
                    \! -name 'slf4j-log4j12*.jar' | sort | tr '\n' ':')

    makeWrapper ${jdk}/bin/java $out/bin/janusgraph-server \
      --add-flags "-classpath $classpath org.janusgraph.graphdb.server.JanusGraphServer"

    makeWrapper ${jdk}/bin/java $out/bin/janusgraph-console \
      --add-flags "-classpath $classpath org.apache.tinkerpop.gremlin.console.Console"

    runHook postInstall
  '';
}
