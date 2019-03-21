{ stdenv, jdk, jre, coursier, makeWrapper }:

let
  baseName = "scalafmt";
  version = "1.5.1";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch com.geirsson:scalafmt-cli_2.12:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "15xfys9wdlx3rrqb2ab6qcfngkf6sa8v8q8shh10kk8jrc30g6dk";
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
