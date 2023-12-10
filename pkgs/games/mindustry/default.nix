{ lib
, stdenv
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchFromGitHub
, gradle
, jdk

# for arc
, SDL2
, pkg-config
, ant
, curl
, wget
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
  version = "146";
  buildVersion = makeBuildVersion version;

  gradleWithJdk = gradle.override { java = jdk; };

  selectedGlew = if enableWayland then glew-egl else glew;

  Mindustry = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    hash = "sha256-pJAJjb8rgDL5q2hfuXH2Cyb1Szu4GixeXoLMdnIAlno=";
  };
  Arc = fetchFromGitHub {
    owner = "Anuken";
    repo = "Arc";
    rev = "v${version}";
    hash = "sha256-L+5fshI1oo1lVdTMTBuPzqtEeR2dq1NORP84rZ83rT0=";
  };
  soloud = fetchFromGitHub {
    owner = "Anuken";
    repo = "soloud";
    # This is pinned in Arc's arc-core/build.gradle
    rev = "v0.9";
    hash = "sha256-6KlqOtA19MxeqZttNyNrMU7pKqzlNiA4rBZKp9ekanc=";
  };

  desktopItem = makeDesktopItem {
    name = "Mindustry";
    desktopName = "Mindustry";
    exec = "mindustry";
    icon = "mindustry";
  };

in
assert lib.assertMsg (enableClient || enableServer)
  "mindustry: at least one of 'enableClient' and 'enableServer' must be true";
stdenv.mkDerivation {
  inherit pname version;

  unpackPhase = ''
    cp -r ${Mindustry} Mindustry
    cp -r ${Arc} Arc
    chmod -R u+w -- Mindustry Arc
    cp -r ${soloud} Arc/arc-core/csrc/soloud
    chmod -R u+w -- Arc/arc-core/csrc/soloud
  '';

  patches = [
    ./0001-fix-include-path-for-SDL2-on-linux.patch
  ];

  postPatch = ''
    # Ensure the prebuilt shared objects don't accidentally get shipped
    rm -r Arc/natives/natives-*/libs/*
    rm -r Arc/backends/backend-*/libs/*

    cd Mindustry

    # Remove unbuildable iOS stuff
    sed -i '/^project(":ios"){/,/^}/d' build.gradle
    sed -i '/robo(vm|VM)/d' build.gradle
    rm ios/build.gradle
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  buildInputs = lib.optionals enableClient [
    SDL2
    selectedGlew
    alsa-lib
  ];
  nativeBuildInputs = [
    pkg-config
    gradleWithJdk
    makeWrapper
    jdk
  ] ++ lib.optionals enableClient [
    ant
    copyDesktopItems
    curl
    wget
  ];

  desktopItems = lib.optional enableClient desktopItem;

  gradleFlags = [ "-Pbuildversion=${buildVersion}" ];

  buildPhase = with lib; optionalString enableClient ''
    pushd ../Arc
    gradle jnigenBuild
    gradle jnigenJarNativesDesktop
    glewlib=${lib.getLib selectedGlew}/lib/libGLEW.so
    sdllib=${lib.getLib SDL2}/lib/libSDL2.so
    patchelf backends/backend-sdl/libs/linux64/libsdl-arc*.so \
      --add-needed $glewlib \
      --add-needed $sdllib
    # Put the freshly-built libraries where the pre-built libraries used to be:
    cp arc-core/libs/*/* natives/natives-desktop/libs/
    cp extensions/freetype/libs/*/* natives/natives-freetype-desktop/libs/
    popd

    gradle desktop:dist
  '' + optionalString enableServer ''
    gradle server:dist
  '';

  installPhase = with lib; let
    installClient = ''
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
    '';
    installServer = ''
      install -Dm644 server/build/libs/server-release.jar $out/share/mindustry-server.jar
      mkdir -p $out/bin
      makeWrapper ${jdk}/bin/java $out/bin/mindustry-server \
        --add-flags "-jar $out/share/mindustry-server.jar"
    '';
  in ''
    runHook preInstall
  '' + optionalString enableClient installClient
     + optionalString enableServer installServer
     + ''
    runHook postInstall
  '';

  passthru = {
    tests.nixosTest = nixosTests.mindustry;

    # Here we download dependencies for both the server and the client so
    # we only have to specify one hash for 'deps'. Deps can be garbage
    # collected after the build, so this is not really an issue.
    updateDeps = gradle.updateDeps {
      inherit pname;
      availablePackages = [ curl wget ];
      postBuild = ''
        # this fetches non-gradle dependencies
        cd ../Arc
        gradle preJni
      '';
    };
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
    platforms = if enableClient then platforms.x86_64 else platforms.linux;
    # Hash mismatch on darwin:
    # https://github.com/NixOS/nixpkgs/pull/105590#issuecomment-737120293
    broken = stdenv.isDarwin;
  };
}
