{ stdenv, jdk, jre, coursier, makeWrapper }:

let
  baseName = "scalafmt";
  version = "2.6.4";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch org.scalameta:scalafmt-cli_2.12:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "1h19rsxsn2piifillv29nwks2k9l391jwygjbfy8pc0ha8yi63mw";
  };
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

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
    homepage = "http://scalameta.org/scalafmt";
    license = licenses.asl20;
    maintainers = [ maintainers.markus1189 ];
  };
}
