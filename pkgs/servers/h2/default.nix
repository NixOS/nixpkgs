{ lib, maven, fetchFromGitHub, jre, makeWrapper, nix-update-script }:

maven.buildMavenPackage rec {
  pname = "h2";
  version = "2.2.224";

  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "h2database";
    repo = "h2database";
    rev = "refs/tags/version-${version}";
    hash = "sha256-pS9jSiuInA0eULPOZK5cjwr9y5KDVY51blhZ9vs4z+g=";
  };

  mvnParameters = "-f h2/pom.xml";
  mvnHash = "sha256-hUzE4F+RNCAfoY836pjrivf04xqN4m9SkiLXhmVzZRA=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/java
    install -Dm644 h2/target/h2-${version}.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/h2 \
      --add-flags "-cp \"$out/share/java/h2-${version}.jar:\$H2DRIVERS:\$CLASSPATH\" org.h2.tools.Console"

    mkdir -p $doc/share/doc/h2
    cp -r h2/src/docsrc/* $doc/share/doc/h2
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "^version-([0-9.]+)$" ];
  };

  meta = with lib; {
    description = "The Java SQL database";
    homepage = "https://h2database.com/html/main.html";
    changelog = "https://h2database.com/html/changelog.html";
    license = licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ mahe anthonyroussel ];
    mainProgram = "h2";
  };
}
