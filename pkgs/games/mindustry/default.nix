{ lib, stdenv, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchFromGitHub
, gradle
, jdk

# for arc
, SDL2
, pkg-config
, stb
, ant
, alsa-lib
, alsa-plugins
, glew
, glew-egl

# for soloud
, libpulseaudio ? null
, libjack2 ? null

, nixosTests


# Make the build version easily overridable.
# Server and client build versions must match, and an empty build version means
# any build is allowed, so this parameter acts as a simple whitelist.
# Takes the package version and returns the build version.
, makeBuildVersion ? (v: v)
, enableClient ? true
, enableServer ? true

, enableWayland ? false
}:

let
  pname = "mindustry";
  version = "144.3";
  buildVersion = makeBuildVersion version;

  selectedGlew = if enableWayland then glew-egl else glew;

  Mindustry = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    hash = "sha256-IXwrBaj0gweaaHefO/LyqEW4a3fBLfySSYPHBhRMVo8=";
  };
  Arc = fetchFromGitHub {
    owner = "Anuken";
    repo = "Arc";
    rev = "v${version}";
    hash = "sha256-nH/sHRWMdX6ieh2EWfD0wAn87E2ZkqZX+9zt2vKYPcE=";
  };
  soloud = fetchFromGitHub {
    owner = "Anuken";
    repo = "soloud";
    # This is pinned in Arc's arc-core/build.gradle
    rev = "v0.9";
    hash = "sha256-6KlqOtA19MxeqZttNyNrMU7pKqzlNiA4rBZKp9ekanc=";
  };
  freetypeSource = fetchurl {
    # This is pinned in Arc's extensions/freetype/build.gradle
    url = "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.gz";
    hash = "sha256-Xqt5XrsjrHcAHPtot9TVC11sdGkkewsBsslTJp9ljaw=";
  };
  glewSource = fetchurl {
    # This is pinned in Arc's backends/backend-sdl/build.gradle
    url = "https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.zip";
    hash = "sha256-qQRqkTd0OVoJXtzAsKwtgcOqzKYXh7OYOblB6b4U4NQ=";
  };
  SDLmingwSource = fetchurl {
    # This is pinned in Arc's backends/backend-sdl/build.gradle
    url = "https://www.libsdl.org/release/SDL2-devel-2.0.20-mingw.tar.gz";
    hash = "sha256-OAlNgqhX1sYjUuXFzex0lIxbTSXFnL0pjW0jNWiXa9E=";
  };

  patches = [
    ./0001-fix-include-path-for-SDL2-on-linux.patch
  ];

  unpackPhase = ''
    cp -r ${Mindustry} Mindustry
    cp -r ${Arc} Arc
    chmod -R u+w -- Mindustry Arc
    cp ${stb.src}/stb_image.h Arc/arc-core/csrc/
    cp -r ${soloud} Arc/arc-core/csrc/soloud
    chmod -R u+w -- Arc
  '';

  desktopItem = makeDesktopItem {
    name = "Mindustry";
    desktopName = "Mindustry";
    exec = "mindustry";
    icon = "mindustry";
  };

  cleanupMindustrySrc = ''
    # Ensure the prebuilt shared objects don't accidentally get shipped
    rm -r Arc/natives/natives-*/libs/*
    rm -r Arc/backends/backend-*/libs/*

    # Remove unbuildable iOS stuff
    sed -i '/^project(":ios"){/,/^}/d' Mindustry/build.gradle
    sed -i '/robo(vm|VM)/d' Mindustry/build.gradle
    rm Mindustry/ios/build.gradle
  '';
in
assert lib.assertMsg (enableClient || enableServer)
  "mindustry: at least one of 'enableClient' and 'enableServer' must be true";
gradle.buildPackage {
  inherit pname version unpackPhase patches;

  gradleOpts = {
    depsHash = "sha256-4PoM8dfDc7KGViPN+9jora/0b4Mh2O8XDbCt7+J1Zp4=";
    lockfileTree = ./lockfiles;
    flags = [ "-Pbuildversion=${buildVersion}" ];
    depsAttrs.initialBuildPhase = ''
      runHook preBuild
    '' + lib.optionalString enableServer ''
      pushd Mindustry
      "''${gradle[@]}" --write-locks nixSupport_downloadDeps
      popd
    '' + lib.optionalString enableClient ''
      pushd Arc
      "''${gradle[@]}" --write-locks nixSupport_downloadDeps
      popd
    '' + ''
      rm -rf $GRADLE_USER_HOME
      export GRADLE_USER_HOME=$(mktemp -d)
    '' + lib.optionalString enableServer ''
      pushd Mindustry
      "''${gradle[@]}" nixSupport_downloadDeps
      popd
    '' + lib.optionalString enableClient ''
      pushd Arc
      "''${gradle[@]}" nixSupport_downloadDeps
      popd
    '' + ''
      runHook postBuild
    '';
    depsAttrs.buildPhase = ''
      runHook preBuild
    '' + lib.optionalString enableServer ''
      pushd Mindustry
      "''${gradle[@]}" nixSupport_downloadDeps
      popd
    '' + lib.optionalString enableClient ''
      pushd Arc
      "''${gradle[@]}" nixSupport_downloadDeps
      popd
    '' + ''
      runHook postBuild
    '';
  };
  doCheck = false;

  postPatch = cleanupMindustrySrc + ''
    # point to offline repo
    sed -ie "s#wget.*freetype.* -O #cp ${freetypeSource} #" Arc/extensions/freetype/build.gradle
    sed -ie "/curl.*glew/{;s#curl -o #cp ${glewSource} #;s# -L http.*\.zip##;}" Arc/backends/backend-sdl/build.gradle
    sed -ie "/curl.*sdlmingw/{;s#curl -o #cp ${SDLmingwSource} #;s# -L http.*\.tar.gz##;}" Arc/backends/backend-sdl/build.gradle
  '';

  buildInputs = lib.optionals enableClient [
    SDL2
    selectedGlew
    alsa-lib
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    jdk
  ] ++ lib.optionals enableClient [
    ant
    copyDesktopItems
  ];

  desktopItems = lib.optional enableClient desktopItem;

  buildPhase = ''
    runHook preBuild
    cd Mindustry
  '' + lib.optionalString enableClient ''
    pwd
    pushd ../Arc
    ''${gradle[@]} jnigenBuild
    ''${gradle[@]} jnigenJarNativesDesktop
    glewlib=${lib.getLib selectedGlew}/lib/libGLEW.so
    sdllib=${lib.getLib SDL2}/lib/libSDL2.so
    patchelf backends/backend-sdl/libs/linux64/libsdl-arc*.so \
      --add-needed $glewlib \
      --add-needed $sdllib
    # Put the freshly-built libraries where the pre-built libraries used to be:
    cp arc-core/libs/*/* natives/natives-desktop/libs/
    p extensions/freetype/libs/*/* natives/natives-freetype-desktop/libs/
    popd

    ''${gradle[@]} desktop:dist
  '' + lib.optionalString enableServer ''
    ''${gradle[@]} server:dist
  '' + ''
    runHook postBuild
  '';

  installPhase = with lib; ''
    runHook preInstall
  '' + optionalString enableClient ''
    install -Dm644 desktop/build/libs/Mindustry.jar $out/share/mindustry.jar
    mkdir -p $out/bin
    makeWrapper ${jdk}/bin/java $out/bin/mindustry \
      --add-flags "-jar $out/share/mindustry.jar" \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libpulseaudio alsa-lib libjack2]} \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib/'' + optionalString enableWayland '' \
      --set SDL_VIDEODRIVER wayland \
      --set SDL_VIDEO_WAYLAND_WMCLASS Mindustry
    '' + ''

    # Retain runtime depends to prevent them from being cleaned up.
    # Since a jar is a compressed archive, nix can't figure out that the dependency is actually in there,
    # and will assume that it's not actually needed.
    # This can cause issues.
    # See https://github.com/NixOS/nixpkgs/issues/109798.
    echo "# Retained runtime dependencies: " >> $out/bin/mindustry
    for dep in ${SDL2.out} ${alsa-lib.out} ${selectedGlew.out}; do
      echo "# $dep" >> $out/bin/mindustry
    done

    install -Dm644 core/assets/icons/icon_64.png $out/share/icons/hicolor/64x64/apps/mindustry.png
  '' + optionalString enableServer ''
    install -Dm644 server/build/libs/server-release.jar $out/share/mindustry-server.jar
    mkdir -p $out/bin
    makeWrapper ${jdk}/bin/java $out/bin/mindustry-server \
      --add-flags "-jar $out/share/mindustry-server.jar"
  '' + ''
    runHook postInstall
  '';

  passthru.tests = {
    nixosTest = nixosTests.mindustry;
  };

  meta = with lib; {
    homepage = "https://mindustrygame.github.io/";
    downloadPage = "https://github.com/Anuken/Mindustry/releases";
    description = "A sandbox tower defense game";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chkno fgaz thekostins ];
    platforms = platforms.x86_64;
    # Hash mismatch on darwin:
    # https://github.com/NixOS/nixpkgs/pull/105590#issuecomment-737120293
    # ---
    # Arc natives aren't being built, so the build phase fails
    broken = true;
  };
}
