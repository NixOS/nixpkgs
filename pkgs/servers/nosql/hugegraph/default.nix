{ stdenv
, hugegraph-unwrapped
, makeWrapper
, jdk
}:

stdenv.mkDerivation {
  pname = "hugegraph";
  inherit (hugegraph-unwrapped) version meta;

  src = hugegraph-unwrapped;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/hugegraph
    cp -r $src/lib $src/conf $src/scripts $out/share/hugegraph

    # Adapted from hugegraph-unwrapped.out/bin/hugegraph-server.sh
    LIB=$out/share/hugegraph/lib
    # Add the slf4j-log4j12 binding
    CP=$(find -L $LIB -name 'log4j-slf4j-impl*.jar' | sort | tr '\n' ':')
    # Add the jars in lib that start with "hugegraph"
    CP="$CP":$(find -L $LIB -name 'hugegraph*.jar' | sort | tr '\n' ':')
    # Add the remaining jars in lib.
    CP="$CP":$(find -L $LIB -name '*.jar' \
                    \! -name 'hugegraph*' \
                    \! -name 'log4j-slf4j-impl*.jar' | sort | tr '\n' ':')

    makeWrapper ${jdk}/bin/java $out/bin/hugegraph-server \
      --add-flags "-classpath $CP com.baidu.hugegraph.dist.HugeGraphServer"

    runHook postInstall
  '';
}
