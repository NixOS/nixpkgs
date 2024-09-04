# Generic builder for shattered pixel forks/mods
{ pname
, version
, src
, meta
, desktopName
, patches ? [ ./disable-beryx.patch ]
, depsPath ? null

, lib
, stdenv
, makeWrapper
, gradle
, perl
, jre
, libGL
, libpulseaudio
, makeDesktopItem
, copyDesktopItems
, ...
}@attrs:

let
  cleanAttrs = builtins.removeAttrs attrs [
    "lib"
    "stdenv"
    "makeWrapper"
    "gradle"
    "perl"
    "jre"
    "libpulseaudio"
    "makeDesktopItem"
    "copyDesktopItems"
  ];

  postPatch = ''
    # disable gradle plugins with native code and their targets
    perl -i.bak1 -pe "s#(^\s*id '.+' version '.+'$)#// \1#" build.gradle
    perl -i.bak2 -pe "s#(.*)#// \1# if /^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar|robovm|git-version)/ ... /^}/" build.gradle
    # Remove unbuildable Android/iOS stuff
    rm -f android/build.gradle ios/build.gradle
    ${attrs.postPatch or ""}
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    inherit desktopName;
    comment = meta.description;
    icon = pname;
    exec = pname;
    terminal = false;
    categories = [ "Game" "AdventureGame" ];
    keywords = [ "roguelike" "dungeon" "crawler" ];
  };

  depsPath' = if depsPath != null then depsPath else ./. + "/${pname}/deps.json";

in stdenv.mkDerivation (cleanAttrs // {
  inherit pname version src patches postPatch;

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = depsPath';
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    gradle
    perl
    makeWrapper
    copyDesktopItems
  ] ++ attrs.nativeBuildInputs or [];

  desktopItems = [ desktopItem ];

  gradleBuildTask = "desktop:release";

  installPhase = ''
    runHook preInstall

    install -Dm644 desktop/build/libs/desktop-*.jar $out/share/${pname}.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL libpulseaudio ]} \
      --add-flags "-jar $out/share/${pname}.jar"

    for s in 16 32 48 64 128 256; do
      # Some forks only have some icons and/or name them slightly differently
      if [ -f desktop/src/main/assets/icons/icon_$s.png ]; then
        install -Dm644 desktop/src/main/assets/icons/icon_$s.png \
          $out/share/icons/hicolor/''${s}x$s/apps/${pname}.png
      fi
      if [ -f desktop/src/main/assets/icons/icon_''${s}x$s.png ]; then
        install -Dm644 desktop/src/main/assets/icons/icon_''${s}x$s.png \
          $out/share/icons/hicolor/''${s}x$s/apps/${pname}.png
      fi
    done

    runHook postInstall
  '';

  meta = with lib; {
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = pname;
  } // meta;
})
