{ lib, stdenv, jdk, jre, coursier, makeWrapper }:

let
  baseName = "scalafix";
  version = "0.9.0";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch ch.epfl.scala:scalafix-cli_2.12.7:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "19j260prx7k010nxyvc1m9jj1ncxr73m2cym7if39360v5dc05c0";
  };
in
stdenv.mkDerivation {
  pname = baseName;
  inherit version;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH scalafix.cli.Cli"
  '';

  installCheckPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Refactoring and linting tool for Scala";
    homepage = "https://scalacenter.github.io/scalafix/";
    license = licenses.bsd3;
    maintainers = [ maintainers.tomahna ];
  };
}
