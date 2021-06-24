{ lib, stdenv
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, fetchFromGitHub
, gradleGen
, jdk
, perl

# for arc
, SDL2
, pkg-config
, stb
, ant
, alsaLib
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
  version = "126.1";
  buildVersion = makeBuildVersion version;

  Mindustry = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    sha256 = "cyg4TofSSFLv8pM3zzvc0FxXMiTm+OIchBJF9PDQrkg=";
  };
  Arc = fetchFromGitHub {
    owner = "Anuken";
    repo = "Arc";
    rev = "v${version}";
    sha256 = "uBIm82mt1etBB/HrNY6XGa7mmBfwd1E3RtqN8Rk5qeY=";
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
    type = "Application";
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

  # The default one still uses jdk8 (#89731)
  gradle_6 = (gradleGen.override (old: { java = jdk; })).gradle_6_8;

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version unpackPhase patches;
    postPatch = cleanupMindustrySrc;

    nativeBuildInputs = [ gradle_6 perl ];
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
    outputHash = "Mw8LZ1iW6vn4RkBBs8SWHp6mo2Bhj7tMZjLbyuJUqSI=";
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
    alsaLib
  ];
  nativeBuildInputs = [
    pkg-config
    gradle_6
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
    patchelf ../Arc/backends/backend-sdl/libs/linux64/libsdl-arc*.so \
      --add-needed ${glew.out}/lib/libGLEW.so \
      --add-needed ${SDL2}/lib/libSDL2.so
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
      --add-flags "-jar $out/share/mindustry.jar"
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz petabyteboy ];
    platforms = platforms.x86_64;
    # Hash mismatch on darwin:
    # https://github.com/NixOS/nixpkgs/pull/105590#issuecomment-737120293
    broken = stdenv.isDarwin
    # does not work with any maintained java version (https://github.com/Anuken/Mindustry/issues/5114)
      || true;
  };
}
