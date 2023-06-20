{ coreutils
, fetchFromGitHub
, gnused
, lib
, maven
, makeWrapper
, openjdk
, stdenv
}:

let
  version = "1.6.56";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
    hash = "sha256-VB/ToTq1XwHPEUNmbocwUoCP4DfyAFdlRAwxrx4tNJU=";
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

  mavenRepository = stdenv.mkDerivation {
    pname = "forge-mtg-maven-repository";
    inherit version src patches;

    nativeBuildInputs = [ maven ];

    buildPhase = ''
      runHook preBuild
      # Tests need a running Xorg.
      mvn package -Dmaven.repo.local=$out -DskipTests
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      find $out -type f \( \
        -name \*.lastUpdated \
        -o -name resolver-status.properties \
        -o -name _remote.repositories \) \
        -delete
      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-aSNqAWbLebmiYnByyw5myc7eivzpP2STStz6qUUMw90=";
  };

in stdenv.mkDerivation {
  pname = "forge-mtg";
  inherit version src patches;

  nativeBuildInputs = [ maven makeWrapper ];

  buildPhase = ''
    runHook preBuild
    # Tests need a running Xorg.
    mvn --offline -Dmaven.repo.local=${mavenRepository} -DskipTests package;
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge
    cp -a \
      forge-gui-desktop/target/forge.sh \
      forge-gui-desktop/target/forge-gui-desktop-${version}-jar-with-dependencies.jar \
      forge-gui-mobile-dev/target/forge-adventure.sh \
      forge-gui-mobile-dev/target/forge-gui-mobile-dev-${version}-jar-with-dependencies.jar \
      forge-adventure/target/forge-adventure-editor.sh \
      forge-adventure/target/forge-adventure-${version}-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${lib.makeBinPath [ coreutils openjdk gnused ]} \
        --set JAVA_HOME ${openjdk}/lib/openjdk \
        --set SENTRY_DSN ""
    done
  '';

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://www.slightlymagic.net/forum/viewforum.php?f=26";
    platforms = openjdk.meta.platforms;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
