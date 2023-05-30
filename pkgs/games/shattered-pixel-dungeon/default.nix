{ lib, stdenv
, makeWrapper
, fetchFromGitHub
, nixosTests
, gradle_6
, jre
, perl
, libpulseaudio
}:

let
  pname = "shattered-pixel-dungeon";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
    # NOTE: always use the commit sha, not the tag. Tags _will_ disappear!
    # https://github.com/00-Evan/shattered-pixel-dungeon/issues/596
    rev = "5d1a2dce6b554b40f6737ead45d411fd98f4c67d";
    sha256 = "sha256-Vu7K0NnqFY298BIQV9AwNEahV0eJl14tAeq+rw6KrtM=";
  };

  postPatch = ''
    # disable gradle plugins with native code and their targets
    perl -i.bak1 -pe "s#(^\s*id '.+' version '.+'$)#// \1#" build.gradle
    perl -i.bak2 -pe "s#(.*)#// \1# if /^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar|robovm)/ ... /^}/" build.gradle
    # Remove unbuildable Android/iOS stuff
    rm android/build.gradle ios/build.gradle
  '';

  gradle = gradle_6;

in gradle.buildPackage rec {
  inherit pname version src postPatch;

  gradleOpts = {
    buildSubcommand = "desktop:release";
    depsHash = "sha256-Kzwk/dJhj7kduIJU6djPACFyJjziPi/oj5cAYesDqrY=";
    lockfileTree = ./lockfiles;
  };

  nativeBuildInputs = [ perl makeWrapper ];

  installPhase = ''
    install -Dm644 desktop/build/libs/desktop-${version}.jar $out/share/shattered-pixel-dungeon.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/shattered-pixel-dungeon \
      --prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib \
      --add-flags "-jar $out/share/shattered-pixel-dungeon.jar"
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
