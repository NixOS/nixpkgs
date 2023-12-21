{ lib, stdenv, jre, coursier, makeWrapper, installShellFiles, setJavaClassPath }:

let
  baseName = "scalafix";
  version = "0.11.1";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch ch.epfl.scala:scalafix-cli_2.13.12:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash     = "sha256-8W0hmQlGhYvaqtYPvpXmWiw1/7yLeYlEpG8wJFov2Jc=";
  };
in
stdenv.mkDerivation {
  pname = baseName;
  inherit version;

  nativeBuildInputs = [ makeWrapper installShellFiles setJavaClassPath ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH scalafix.cli.Cli"

    installShellCompletion --cmd ${baseName} \
      --bash <($out/bin/${baseName} --bash) \
      --zsh  <($out/bin/${baseName} --zsh)
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
