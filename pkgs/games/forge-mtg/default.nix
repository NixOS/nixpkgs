{ coreutils
, fetchFromGitHub
, gnused
, lib
, maven
, makeWrapper
, openjdk
<<<<<<< HEAD
}:

let
  version = "1.6.57";
=======
, stdenv
}:

let
  version = "1.6.53";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
<<<<<<< HEAD
    hash = "sha256-pxnnqLfyblbIgIRZZrx8Y8K43zUv9mu7PzZ7zltpEUQ=";
=======
    sha256 = "sha256-tNPG90mw8HZjp37YJ9JQlOBiVNPRo6xuNur651Adva8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

<<<<<<< HEAD
in
maven.buildMavenPackage {
  pname = "forge-mtg";
  inherit version src patches;

  # Tests need a running Xorg.
  mvnParameters = "-DskipTests";
  mvnHash = "sha256-QK9g0tG75lIhEtf4jW03N32YbD9Fe5iI0JTuqmCTtnE=";

  nativeBuildInputs = [ makeWrapper ];
=======
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
    outputHash = "sha256-6FTbYXaF3rBIZov2WJxjG/ovmvimjXFPaFchAduVzI8=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge
    cp -a \
      forge-gui-desktop/target/forge.sh \
      forge-gui-desktop/target/forge-gui-desktop-${version}-jar-with-dependencies.jar \
<<<<<<< HEAD
      forge-gui-mobile-dev/target/forge-adventure.sh \
      forge-gui-mobile-dev/target/forge-gui-mobile-dev-${version}-jar-with-dependencies.jar \
      forge-adventure/target/forge-adventure-editor.sh \
=======
      forge-adventure/target/forge-adventure.sh \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      forge-adventure/target/forge-adventure-${version}-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    runHook postInstall
  '';

  preFixup = ''
<<<<<<< HEAD
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
=======
    for commandToInstall in forge forge-adventure; do
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    platforms = openjdk.meta.platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
