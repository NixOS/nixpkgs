{
  lib,
  stdenv,
  jre,
  coursier,
  makeWrapper,
  installShellFiles,
  setJavaClassPath,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "scalafix";
  version = "0.12.0";
  deps = stdenv.mkDerivation {
    name = "${finalAttrs.pname}-deps-${finalAttrs.version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch ch.epfl.scala:scalafix-cli_2.13.13:${finalAttrs.version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-HMTnr3awTIAgLSl4eF36U1kv162ajJxC5MreSk2TfUE=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    setJavaClassPath
  ];
  buildInputs = [ finalAttrs.deps ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${finalAttrs.pname} \
      --add-flags "-cp $CLASSPATH scalafix.cli.Cli"

    installShellCompletion --cmd ${finalAttrs.pname} \
      --bash <($out/bin/${finalAttrs.pname} --bash) \
      --zsh  <($out/bin/${finalAttrs.pname} --zsh)
  '';

  passthru.tests = {
    testVersion = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "${finalAttrs.version}";
    };
  };

  meta = with lib; {
    description = "Refactoring and linting tool for Scala";
    mainProgram = "scalafix";
    homepage = "https://scalacenter.github.io/scalafix/";
    license = licenses.bsd3;
    maintainers = [ maintainers.tomahna ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
