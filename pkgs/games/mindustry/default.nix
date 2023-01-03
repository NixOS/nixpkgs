{ lib, stdenv, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchFromGitHub
, gradle
, jdk
, perl

# for arc
, SDL2
, pkg-config
, stb
, ant
, alsa-lib
, alsa-plugins
, glew

# for soloud
, libpulseaudio ? null
, libjack2 ? null


# Make the build version easily overridable.
# Server and client build versions must match, and an empty build version means
# any build is allowed, so this parameter acts as a simple whitelist.
# Takes the package version and returns the build version.
, makeBuildVersion ? (v: v)
, enableClient ? true
, enableServer ? true
}:

let
  pname = "mindustry";
  version = "140.4";
  buildVersion = makeBuildVersion version;

  Mindustry = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    sha256 = "0lfDISvC5dOd76BuPPniPf+8hXWQ/wtreNHN75k2jVA=";
  };
  Arc = fetchFromGitHub {
    owner = "Anuken";
    repo = "Arc";
    rev = "v${version}";
    sha256 = "lZ3ACijauUC9jVRq9I/QwX9ozFF/dw+ArEMND+RMItM=";
  };
  soloud = fetchFromGitHub {
    owner = "Anuken";
    repo = "soloud";
    # This is pinned in Arc's arc-core/build.gradle
    rev = "v0.9";
    sha256 = "6KlqOtA19MxeqZttNyNrMU7pKqzlNiA4rBZKp9ekanc=";
  };
  freetypeSource = fetchurl {
    # This is pinned in Arc's extensions/freetype/build.gradle
    url = "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.gz";
    sha256 = "1b4dcngjcly9n80hnyr4d5s6qp8bspabfs7v3h07gb13pdg7kasy";
  };
  glewSource = fetchurl {
    # This is pinned in Arc's backends/backend-sdl/build.gradle
    url = "https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.zip";
    sha256 = "1m702jzfjhdr76cb71qplv6amhw15nnb1h6wbq4mlfbl6y8nl159";
  };
  SDLmingwSource = fetchurl {
    # This is pinned in Arc's backends/backend-sdl/build.gradle
    url = "https://www.libsdl.org/release/SDL2-devel-2.0.20-mingw.tar.gz";
    sha256 = "1lbbjxl3a8vdillvv7654m6mp34lfkncvig5a8iwdmjpm214s29q";
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

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version unpackPhase patches;
    postPatch = cleanupMindustrySrc;

    nativeBuildInputs = [ gradle perl ];
    # Here we download dependencies for both the server and the client so
    # we only have to specify one hash for 'deps'. Deps can be garbage
    # collected after the build, so this is not really an issue.
    buildPhase = ''
      pushd Mindustry
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon resolveDependencies
      popd
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "FbLd3kk/awFz91o8pZcwJTFozwJ7R+RlDOsMRaala5Q=";
  };

in
assert lib.assertMsg (enableClient || enableServer)
  "mindustry: at least one of 'enableClient' and 'enableServer' must be true";
stdenv.mkDerivation rec {
  inherit pname version unpackPhase patches;

  postPatch = cleanupMindustrySrc;

  buildInputs = lib.optionals enableClient [
    SDL2
    glew
    alsa-lib
  ];
  nativeBuildInputs = [
    pkg-config
    gradle
    makeWrapper
    jdk
  ] ++ lib.optionals enableClient [
    ant
    copyDesktopItems
  ];

  desktopItems = lib.optional enableClient desktopItem;

  buildPhase = with lib; ''
    export GRADLE_USER_HOME=$(mktemp -d)

    # point to offline repo
    sed -ie "1ipluginManagement { repositories { maven { url '${deps}' } } }; " Mindustry/settings.gradle
    sed -ie "s#mavenLocal()#mavenLocal(); maven { url '${deps}' }#g" Mindustry/build.gradle
    sed -ie "s#mavenCentral()#mavenCentral(); maven { url '${deps}' }#g" Arc/build.gradle
    sed -ie "s#wget.*freetype.* -O #cp ${freetypeSource} #" Arc/extensions/freetype/build.gradle
    sed -ie "/curl.*glew/{;s#curl -o #cp ${glewSource} #;s# -L http.*\.zip##;}" Arc/backends/backend-sdl/build.gradle
    sed -ie "/curl.*sdlmingw/{;s#curl -o #cp ${SDLmingwSource} #;s# -L http.*\.tar.gz##;}" Arc/backends/backend-sdl/build.gradle

    pushd Mindustry
  '' + optionalString enableClient ''

    pushd ../Arc
    gradle --offline --no-daemon jnigenBuild -Pbuildversion=${buildVersion}
    gradle --offline --no-daemon jnigenJarNativesDesktop -Pbuildversion=${buildVersion}
    glewlib=${lib.getLib glew}/lib/libGLEW.so
    sdllib=${lib.getLib SDL2}/lib/libSDL2.so
    patchelf backends/backend-sdl/libs/linux64/libsdl-arc*.so \
      --add-needed $glewlib \
      --add-needed $sdllib
    # Put the freshly-built libraries where the pre-built libraries used to be:
    cp arc-core/libs/*/* natives/natives-desktop/libs/
    cp extensions/freetype/libs/*/* natives/natives-freetype-desktop/libs/
    popd

    gradle --offline --no-daemon desktop:dist -Pbuildversion=${buildVersion}
  '' + optionalString enableServer ''
    gradle --offline --no-daemon server:dist -Pbuildversion=${buildVersion}
  '';

  installPhase = with lib; ''
    runHook preInstall
  '' + optionalString enableClient ''
    install -Dm644 desktop/build/libs/Mindustry.jar $out/share/mindustry.jar
    mkdir -p $out/bin
    makeWrapper ${jdk}/bin/java $out/bin/mindustry \
      --add-flags "-jar $out/share/mindustry.jar" \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libpulseaudio alsa-lib libjack2]} \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib/

    # Retain runtime depends to prevent them from being cleaned up.
    # Since a jar is a compressed archive, nix can't figure out that the dependency is actually in there,
    # and will assume that it's not actually needed.
    # This can cause issues.
    # See https://github.com/NixOS/nixpkgs/issues/109798.
    echo "# Retained runtime dependencies: " >> $out/bin/mindustry
    for dep in ${SDL2.out} ${alsa-lib.out} ${glew.out}; do
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

  meta = with lib; {
    homepage = "https://mindustrygame.github.io/";
    downloadPage = "https://github.com/Anuken/Mindustry/releases";
    description = "A sandbox tower defense game";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chkno fgaz ];
    platforms = platforms.x86_64;
    # Hash mismatch on darwin:
    # https://github.com/NixOS/nixpkgs/pull/105590#issuecomment-737120293
    broken = stdenv.isDarwin;
  };
}
