{ lib, stdenv
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchFromGitHub
, gradle_6
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
  # Note: when raising the version, ensure that all SNAPSHOT versions in
  # build.gradle are replaced by a fixed version
  # (the current one at the time of release) (see postPatch).
  version = "126.2";
  buildVersion = makeBuildVersion version;

  Mindustry = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    sha256 = "URmjmfzQAVVl6erbh3+FVFdN7vGTNwYKPtcrwtt9vkg=";
  };
  Arc = fetchFromGitHub {
    owner = "Anuken";
    repo = "Arc";
    rev = "v${version}";
    sha256 = "pUUak5P9t4RmSdT+/oH/8oo6l7rjIN08XDJ06TcUn8I=";
  };
  soloud = fetchFromGitHub {
    owner = "Anuken";
    repo = "soloud";
    # this is never pinned in upstream, see https://github.com/Anuken/Arc/issues/39
    rev = "b33dfc5178fcb2613ee68136f4a4869cadc0b06a";
    sha256 = "1vf68i3pnsixch37285ib7afkwmlrc05v783395jsdjzj9i67lj3";
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
    pushd Mindustry

    # Remove unbuildable iOS stuff
    sed -i '/^project(":ios"){/,/^}/d' build.gradle
    sed -i '/robo(vm|VM)/d' build.gradle
    rm ios/build.gradle

    # Pin 'SNAPSHOT' versions
    sed -i 's/com.github.anuken:packr:-SNAPSHOT/com.github.anuken:packr:034efe51781d2d8faa90370492133241bfb0283c/' build.gradle

    popd
  '';

  gradle = (gradle_6.override (old: { java = jdk; }));

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
    outputHash = "+7vSwQT6LwHgKE9DubISznq4G4DgvlnD7WaF1KywBzU=";
  };

in
assert lib.assertMsg (enableClient || enableServer)
  "mindustry: at least one of 'enableClient' and 'enableServer' must be true";
stdenv.mkDerivation rec {
  inherit pname version unpackPhase patches;

  postPatch = ''
    # ensure the prebuilt shared objects don't accidentally get shipped
    rm Arc/natives/natives-desktop/libs/libarc*.so
    rm Arc/backends/backend-sdl/libs/linux64/libsdl-arc*.so
  '' + cleanupMindustrySrc;

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
    sed -ie "s#mavenLocal()#mavenLocal(); maven { url '${deps}' }#g" Mindustry/build.gradle
    sed -ie "s#mavenCentral()#mavenCentral(); maven { url '${deps}' }#g" Arc/build.gradle

    pushd Mindustry
  '' + optionalString enableClient ''
    gradle --offline --no-daemon jnigenBuild -Pbuildversion=${buildVersion}
    gradle --offline --no-daemon sdlnatives -Pdynamic -Pbuildversion=${buildVersion}
    glewlib=${lib.getLib glew}/lib/libGLEW.so
    sdllib=${lib.getLib SDL2}/lib/libSDL2.so
    patchelf ../Arc/backends/backend-sdl/libs/linux64/libsdl-arc*.so \
      --add-needed $glewlib \
      --add-needed $sdllib
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
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.x86_64;
    # Hash mismatch on darwin:
    # https://github.com/NixOS/nixpkgs/pull/105590#issuecomment-737120293
    broken = stdenv.isDarwin;
  };
}
