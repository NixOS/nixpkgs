{ stdenv, lib, coursier, jre, makeWrapper, setJavaClassPath }:

stdenv.mkDerivation rec {
  pname = "metals";
  version = "0.11.12";

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
    outputHash = "sha256-3zYjjrd3Hc2T4vwnajiAMNfTDUprKJZnZp2waRLQjI4=";
  };

  nativeBuildInputs = [ makeWrapper setJavaClassPath ];
  buildInputs = [ deps ];

  dontUnpack = true;

  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/metals \
      --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"
  '';

  meta = with lib; {
    homepage = "https://scalameta.org/metals/";
    license = licenses.asl20;
    description = "Work-in-progress language server for Scala";
    maintainers = with maintainers; [ fabianhjr tomahna ];
  };
}
