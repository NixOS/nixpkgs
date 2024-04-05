{
  lib,
  stdenv,
  jre,
  coursier,
  makeWrapper,
  installShellFiles,
  setJavaClassPath,
}:
stdenv.mkDerivation rec {
  pname = "scalafix";
  version = "0.12.0";
  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch ch.epfl.scala:scalafix-cli_2.13.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-HMTnr3awTIAgLSl4eF36U1kv162ajJxC5MreSk2TfUE=";
  };

  nativeBuildInputs = [makeWrapper installShellFiles setJavaClassPath];
  buildInputs = [deps];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-cp $CLASSPATH scalafix.cli.Cli"

    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} --bash) \
      --zsh  <($out/bin/${pname} --zsh)
  '';

  installCheckPhase = ''
    $out/bin/${pname} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Refactoring and linting tool for Scala";
    homepage = "https://scalacenter.github.io/scalafix/";
    license = licenses.bsd3;
    maintainers = [maintainers.tomahna];
  };
}
