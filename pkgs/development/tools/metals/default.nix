{ stdenv, lib, coursier, jdk, jre, makeWrapper }:

let
  baseName = "metals";
  version = "0.8.1";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "0m1vly213cazylg1rmfh5qk3bq65aafa0rf1anfdb3ggymylwza0";
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

  phases = [ "installPhase" ];

  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

  installPhase = ''
    mkdir -p $out/bin

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

  meta = with stdenv.lib; {
    homepage = https://scalameta.org/metals/;
    license = licenses.asl20;
    description = "Work-in-progress language server for Scala";
    maintainers = with maintainers; [ ceedubs tomahna ];
  };
}
