{ stdenv, jdk, jre, coursier, makeWrapper }:

let
  baseName = "scalafmt";
  version = "1.3.0";
  deps = stdenv.mkDerivation {
    name = "${baseName}-${version}-deps";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      mkdir -p $out/share/java
      cp $(${coursier}/bin/coursier fetch com.geirsson:scalafmt-cli_2.12:${version}) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "0q1vw6drpdrfifbm3266igpml0phdk6pl0gd3b5amysigx83m251";
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  buildInputs = [ jdk makeWrapper deps ];

  doCheck = true;

  phases = [ "installPhase" "checkPhase" ];

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH org.scalafmt.cli.Cli"
  '';

  checkPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "Opinionated code formatter for Scala";
    homepage = http://scalafmt.org;
    license = licenses.asl20;
    maintainers = [ maintainers.markus1189 ];
  };
}
