{ stdenv, lib, coursier, jre, makeWrapper, setJavaClassPath }:

stdenv.mkDerivation rec {
  pname = "metals";
  version = "0.11.5";

  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "sha256-kw+8688E1b7XjEb7AqOExSVu88NqPprKaCuINWqL2wk=";
  };

  nativeBuildInputs = [ makeWrapper setJavaClassPath ];
  buildInputs = [ deps ];

  dontUnpack = true;

  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

  installPhase = ''
    mkdir -p $out/bin

    # This variant is not targeted at any particular client, clients are
    # expected to declare their supported features in initialization options.
    makeWrapper ${jre}/bin/java $out/bin/metals \
      --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"

    # Further variants targeted at clients with featuresets pre-set.
    makeWrapper ${jre}/bin/java $out/bin/metals-emacs \
      --add-flags "${extraJavaOpts} -Dmetals.client=emacs -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-vim \
      --add-flags "${extraJavaOpts} -Dmetals.client=coc.nvim -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-vim-lsc \
      --add-flags "${extraJavaOpts} -Dmetals.client=vim-lsc -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-sublime \
      --add-flags "${extraJavaOpts} -Dmetals.client=sublime -cp $CLASSPATH scala.meta.metals.Main"
  '';

  meta = with lib; {
    homepage = "https://scalameta.org/metals/";
    license = licenses.asl20;
    description = "Work-in-progress language server for Scala";
    maintainers = with maintainers; [ fabianhjr tomahna ];
  };
}
