{ lib, stdenv, jre, coursier, makeWrapper, setJavaClassPath }:

let
  baseName = "scalafmt";
<<<<<<< HEAD
  version = "3.7.9";
=======
  version = "3.7.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:scalafmt-cli_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
<<<<<<< HEAD
    outputHash = "sha256-r4vv62H0AryjZb+34fVHvqvndipOYyf6XpQC9u8Dxso=";
=======
    outputHash     = "sha256-iV6tj7pLXWJU0uV0xAk2gJrH5vPIqojDQuCk6NxAAw4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
stdenv.mkDerivation {
  pname = baseName;
  inherit version;

  nativeBuildInputs = [ makeWrapper setJavaClassPath ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH org.scalafmt.cli.Cli"

    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Opinionated code formatter for Scala";
    homepage = "http://scalameta.org/scalafmt";
    license = licenses.asl20;
    maintainers = [ maintainers.markus1189 ];
<<<<<<< HEAD
    mainProgram = "scalafmt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
