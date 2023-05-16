{ stdenv, lib, coursier, jre, makeWrapper, setJavaClassPath }:

stdenv.mkDerivation rec {
  pname = "metals";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.11.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
<<<<<<< HEAD
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-AamUE6mr9fwjbDndQtzO2Yscu2T6zUW/DiXMYwv35YE=";
=======
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-3zYjjrd3Hc2T4vwnajiAMNfTDUprKJZnZp2waRLQjI4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "Language server for Scala";
=======
    description = "Work-in-progress language server for Scala";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ fabianhjr tomahna ];
  };
}
