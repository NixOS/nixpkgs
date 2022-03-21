{ stdenv, lib, coursier, jdk, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "metals";
  version = "0.11.2";

  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:metals_2.12:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "sha256-sriiHgKs2hC8inBGWuLM9qFfGgtcYqKHh0VZWNmg51U=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

  dontUnpack = true;

  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

  installPhase = ''
    mkdir -p $out/bin

    # This variant is not targeted at any particular client, clients are
    # expected to declare their supported features in initialization options.
    makeWrapper ${jre}/bin/java $out/bin/metals \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"

    # Further variants targeted at clients with featuresets pre-set.
    makeWrapper ${jre}/bin/java $out/bin/metals-emacs \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "${extraJavaOpts} -Dmetals.client=emacs -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-vim \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "${extraJavaOpts} -Dmetals.client=coc.nvim -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-vim-lsc \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "${extraJavaOpts} -Dmetals.client=vim-lsc -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-sublime \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "${extraJavaOpts} -Dmetals.client=sublime -cp $CLASSPATH scala.meta.metals.Main"
  '';

  meta = with lib; {
    homepage = "https://scalameta.org/metals/";
    license = licenses.asl20;
    description = "Work-in-progress language server for Scala";
    maintainers = with maintainers; [ fabianhjr tomahna ];
  };
}
