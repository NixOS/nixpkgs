# Generic builder for shattered pixel forks/mods
{
  pname,
  version,
  src,
  depsHash,
  meta,
  desktopName,
  patches ? [ ./disable-beryx.patch ],

  lib,
  stdenv,
  makeWrapper,
  gradle,
  perl,
  jre,
  libGL,
  libpulseaudio,
  makeDesktopItem,
  copyDesktopItems,
  ...
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
    categories = [
      "Game"
      "AdventureGame"
    ];
    keywords = [
      "roguelike"
      "dungeon"
      "crawler"
    ];
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit
      version
      src
      patches
      postPatch
      ;
    nativeBuildInputs = [
      gradle
      perl
    ] ++ attrs.nativeBuildInputs or [ ];
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
    outputHash = depsHash;
  };

in
stdenv.mkDerivation (
  cleanAttrs
  // {
    inherit
      pname
      version
      src
      patches
      postPatch
      ;

    nativeBuildInputs = [
      gradle
      perl
      makeWrapper
      copyDesktopItems
    ] ++ attrs.nativeBuildInputs or [ ];

    desktopItems = [ desktopItem ];

    buildPhase = ''
      runHook preBuild

      export GRADLE_USER_HOME=$(mktemp -d)
      # https://github.com/gradle/gradle/issues/4426
      ${lib.optionalString stdenv.isDarwin "export TERM=dumb"}
      # point to offline repo
      sed -ie "s#repositories {#repositories { maven { url '${deps}' };#g" build.gradle
      gradle --offline --no-daemon desktop:release

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm644 desktop/build/libs/desktop-*.jar $out/share/${pname}.jar
      mkdir $out/bin
      makeWrapper ${jre}/bin/java $out/bin/${pname} \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libGL
            libpulseaudio
          ]
        } \
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

    meta =
      with lib;
      {
        sourceProvenance = with sourceTypes; [
          fromSource
          binaryBytecode # deps
        ];
        license = licenses.gpl3Plus;
        maintainers = with maintainers; [ fgaz ];
        platforms = platforms.all;
        # https://github.com/NixOS/nixpkgs/pull/99885#issuecomment-740065005
        broken = stdenv.isDarwin;
        mainProgram = pname;
      }
      // meta;
  }
)
