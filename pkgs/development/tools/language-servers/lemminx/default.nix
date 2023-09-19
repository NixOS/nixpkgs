{
  lib, fetchFromGitHub, makeWrapper, jre, maven
}:

maven.buildMavenPackage rec {
  pname = "lemminx";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "lemminx";
    rev = version;
    hash = "sha256-8pHTfncM7N+IGB6NHQOZBqBKs6xKol9pvLDAbKTpPw4=";
  };

  prePatch = ''
  cat > ./org.eclipse.lemminx/src/main/resources/git.properties << EOF
  git.build.version=${version}-
  git.commit.id.abbrev=abcdefg
  git.commit.message.short=Latest
  git.branch=main
  EOF
  '';

  mvnHash = "sha256-sIiCp1AorVQXt13Tq0vw9jGioG3zcQMqqKS/Q0Tf4MQ=";

  buildOffline = true;
  mvnDepsParameters = "-Dmaven.gitcommitid.skip=true";
  mvnParameters = "-Dmaven.gitcommitid.skip=true -Dtest='!XMLValidationCommandTest, !XMLValidationExternalResourcesBasedOnDTDTest, !XMLSchemaPublishDiagnosticsTest'";

  # not needed for lemminx because we will disable tests as they are depending
  # on the .git folder which makes the package not deterministic. Just here
  # to showcase the usage.

  manualMvnArtifacts = [
    "org.apache.maven.surefire:surefire-junit-platform:3.1.2"
    "org.junit.platform:junit-platform-launcher:1.10.0"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    ls org.eclipse.lemminx/target
    install -Dm644 org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar \
      $out/share

    makeWrapper ${jre}/bin/java $out/bin/lemminx \
      --add-flags "-jar $out/share/org.eclipse.lemminx-uber.jar"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "XML Language Server";
    homepage = "https://github.com/eclipse/lemminx";
    license = licenses.epl20;
    maintainers = with maintainers; [ tricktron ];
  };
}
