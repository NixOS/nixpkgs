{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk
, jre
, makeWrapper
, stripJavaArchivesHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "javacc";
  version = "7.0.13";

  src = fetchFromGitHub {
    owner = "javacc";
    repo = "javacc";
    rev = "javacc-${finalAttrs.version}";
    hash = "sha256-nDJvKIbJc23Tvfn7Zqvt5tDDffNf4KQ0juGQQCZ+i1c=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant jar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 target/javacc.jar -t $out/target
    install -Dm755 scripts/{javacc,jjdoc,jjtree,jjrun} -t $out/bin

    for file in $out/bin/*; do
      wrapProgram "$file" --suffix PATH : ${jre}/bin
    done

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ant test
    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://github.com/javacc/javacc/blob/${finalAttrs.src.rev}/docs/release-notes.md";
    description = "Parser generator for building parsers from grammars";
    homepage = "https://javacc.github.io/javacc";
    license = licenses.bsd2;
    mainProgram = "javacc";
    maintainers = teams.deshaw.members;
  };
})
