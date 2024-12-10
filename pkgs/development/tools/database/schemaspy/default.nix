{
  lib,
  maven,
  jre,
  makeWrapper,
  git,
  fetchFromGitHub,
  graphviz,
  ensureNewerSourcesHook,
}:

maven.buildMavenPackage rec {
  pname = "schemaspy";
  version = "6.1.1-SNAPSHOT";

  src = fetchFromGitHub {
    owner = "schemaspy";
    repo = "schemaspy";
    rev = "110b1614f9ae4aec0e4dc4e8f0e7c647274d3af6";
    hash = "sha256-X5B34zGhD/NxcK8TQvwdk1NljGJ1HwfBp47ocbE4HiU=";
  };

  mvnParameters = "-Dmaven.test.skip=true";
  mvnFetchExtraArgs = {
    nativeBuildInputs = [
      # the build system gets angry if it doesn't see git (even though it's not
      # actually in a git repository)
      git
      maven
    ];
  };
  mvnHash = "sha256-1x6cNt6t3FnjRNg8iNYflkyDnuPFXGKoxhVJWoz2jIU=";

  nativeBuildInputs = [
    makeWrapper
    git

    # springframework boot gets angry about 1970 sources
    # fix from https://github.com/nix-community/mavenix/issues/25
    (ensureNewerSourcesHook { year = "1980"; })
  ];

  wrappedPath = lib.makeBinPath [
    graphviz
  ];

  preBuild = ''
    VERSION=${version}
    SEMVER_STR=${version}
  '';

  installPhase = ''
    install -D target/${pname}-${version}.jar $out/share/java/${pname}-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/schemaspy \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar" \
      --prefix PATH : "$wrappedPath"
  '';

  meta = with lib; {
    homepage = "https://schemaspy.org";
    description = "Document your database simply and easily";
    mainProgram = "schemaspy";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
