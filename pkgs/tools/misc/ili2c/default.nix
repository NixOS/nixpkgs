{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk8
, jre8
, makeWrapper
, stripJavaArchivesHook
}:

let
  jdk = jdk8;
  jre = jre8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ili2c";
  version = "5.1.1"; # There are newer versions, but they use gradle

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  src = fetchFromGitHub {
    owner = "claeis";
    repo = "ili2c";
    rev = "ili2c-${finalAttrs.version}";
    hash = "sha256-FHhx+f253+UdbFjd2fOlUY1tpQ6pA2aVu9CBSwUVoKQ=";
  };

  patches = [
    # avoids modifying Version.properties file because that would insert the current timestamp into the file
    ./dont-use-build-timestamp.patch
  ];

  buildPhase = ''
    runHook preBuild
    ant jar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/jar/ili2c.jar -t $out/share/ili2c
    makeWrapper ${jre}/bin/java $out/bin/ili2c \
        --add-flags "-jar $out/share/ili2c/ili2c.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "INTERLIS Compiler";
    longDescription = ''
      Checks the syntactical correctness of an INTERLIS data model.
    '';
    homepage = "https://www.interlis.ch/downloads/ili2c";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ das-g ];
    platforms = platforms.unix;
    mainProgram = "ili2c";
  };
})
