{ lib, stdenv
, makeWrapper
, fetchFromGitHub
, nixosTests
<<<<<<< HEAD
, gradle
, perl
, jre
, libpulseaudio
, makeDesktopItem
, copyDesktopItems
=======
, gradle_6
, perl
, jre
, libpulseaudio
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  pname = "shattered-pixel-dungeon";
<<<<<<< HEAD
  version = "2.1.4";
=======
  version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-WbRvsHxTYYlhJavYVGMGK25fXEfSfnIztJ6KuCgBjF8=";
  };

  patches = [
    ./disable-beryx.patch
  ];

=======
    # NOTE: always use the commit sha, not the tag. Tags _will_ disappear!
    # https://github.com/00-Evan/shattered-pixel-dungeon/issues/596
    rev = "5d1a2dce6b554b40f6737ead45d411fd98f4c67d";
    sha256 = "sha256-Vu7K0NnqFY298BIQV9AwNEahV0eJl14tAeq+rw6KrtM=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    # disable gradle plugins with native code and their targets
    perl -i.bak1 -pe "s#(^\s*id '.+' version '.+'$)#// \1#" build.gradle
    perl -i.bak2 -pe "s#(.*)#// \1# if /^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar|robovm)/ ... /^}/" build.gradle
    # Remove unbuildable Android/iOS stuff
    rm android/build.gradle ios/build.gradle
  '';

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
<<<<<<< HEAD
    inherit version src patches postPatch;
    nativeBuildInputs = [ gradle perl ];
=======
    inherit version src postPatch;
    nativeBuildInputs = [ gradle_6 perl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      # https://github.com/gradle/gradle/issues/4426
      ${lib.optionalString stdenv.isDarwin "export TERM=dumb"}
      gradle --no-daemon desktop:release
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashMode = "recursive";
<<<<<<< HEAD
    outputHash = "sha256-i4k5tdo07E1NJwywroaGvRjZ+/xrDp6ra+GTYwTB7uk=";
  };

  desktopItem = makeDesktopItem {
    name = "shattered-pixel-dungeon";
    desktopName = "Shattered Pixel Dungeon";
    comment = "An open-source traditional roguelike dungeon crawler";
    icon = "shattered-pixel-dungeon";
    exec = "shattered-pixel-dungeon";
    terminal = false;
    categories = [ "Game" "AdventureGame" ];
    keywords = [ "roguelike" "dungeon" "crawler" ];
  };

in stdenv.mkDerivation rec {
  inherit pname version src patches postPatch;

  nativeBuildInputs = [ gradle perl makeWrapper copyDesktopItems ];

  desktopItems = [ desktopItem ];

  buildPhase = ''
    runHook preBuild

=======
    outputHash = "sha256-UI5/ZJbUtEz1Fr+qn6a8kzi9rrP+lVrpBbuDv8TG5y0=";
  };

in stdenv.mkDerivation rec {
  inherit pname version src postPatch;

  nativeBuildInputs = [ gradle_6 perl makeWrapper ];

  buildPhase = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    export GRADLE_USER_HOME=$(mktemp -d)
    # https://github.com/gradle/gradle/issues/4426
    ${lib.optionalString stdenv.isDarwin "export TERM=dumb"}
    # point to offline repo
    sed -ie "s#repositories {#repositories { maven { url '${deps}' };#g" build.gradle
    gradle --offline --no-daemon desktop:release
<<<<<<< HEAD

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

=======
  '';

  installPhase = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    install -Dm644 desktop/build/libs/desktop-${version}.jar $out/share/shattered-pixel-dungeon.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/shattered-pixel-dungeon \
      --prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib \
      --add-flags "-jar $out/share/shattered-pixel-dungeon.jar"
<<<<<<< HEAD

    for s in 16 32 48 64 128 256; do
      install -Dm644 desktop/src/main/assets/icons/icon_$s.png \
        $out/share/icons/hicolor/''${s}x$s/apps/shattered-pixel-dungeon.png
    done

    runHook postInstall
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  passthru.tests = {
    shattered-pixel-dungeon-starts = nixosTests.shattered-pixel-dungeon;
  };

  meta = with lib; {
    homepage = "https://shatteredpixel.com/";
    downloadPage = "https://github.com/00-Evan/shattered-pixel-dungeon/releases";
    description = "Traditional roguelike game with pixel-art graphics and simple interface";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # https://github.com/NixOS/nixpkgs/pull/99885#issuecomment-740065005
    broken = stdenv.isDarwin;
  };
}
