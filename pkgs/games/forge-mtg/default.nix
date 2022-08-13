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
  version = "1.6.53";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
    sha256 = "sha256-tNPG90mw8HZjp37YJ9JQlOBiVNPRo6xuNur651Adva8=";
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

  installPhase = ''
    runHook preInstall
    mkdir -pv $out/{bin,share/forge}
    cp -av \
      forge-gui-desktop/target/forge.sh \
      forge-gui-desktop/target/forge-gui-desktop-${version}-jar-with-dependencies.jar \
      forge-adventure/target/forge-adventure.sh \
      forge-adventure/target/forge-adventure-${version}-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure; do
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
