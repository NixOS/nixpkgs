{ stdenv
, makeWrapper
, makeDesktopItem
, fetchFromGitHub
, gradleGen
, jdk14
, perl
, jre
, alsaLib

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
  version = "122";
  buildVersion = makeBuildVersion version;

  src = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    sha256 = "19dxqscnny0c5w3pyg88hflrkhsqgd7zx19240kh4h69y3wwaz0m";
  };

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "Mindustry";
    desktopName = "Mindustry";
    exec = "mindustry";
    icon = "mindustry";
  };

  postPatch = ''
    # Remove unbuildable iOS stuff
    sed -i '/^project(":ios"){/,/^}/d' build.gradle
    sed -i '/robo(vm|VM)/d' build.gradle
    rm ios/build.gradle

    # Pin 'SNAPSHOT' versions
    sed -i 's/com.github.anuken:packr:-SNAPSHOT/com.github.anuken:packr:034efe51781d2d8faa90370492133241bfb0283c/' build.gradle
  '';

  preBuild = ''
    # Arc is run at build time for sprite packing, and it needs to see
    # the runtime libraries
    ${stdenv.lib.optionalString stdenv.isLinux "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${alsaLib}/lib"}
    export GRADLE_USER_HOME=$(mktemp -d)
  '';

  # The default one still uses jdk8 (#89731)
  gradle_6 = (gradleGen.override (old: { java = jdk14; })).gradle_6_7;

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src postPatch;
    nativeBuildInputs = [ gradle_6 perl ];
    # Here we build both the server and the client so we only have to specify
    # one hash for 'deps'. Deps can be garbage collected after the build,
    # so this is not really an issue.
    buildPhase = ''
      ${preBuild}
      gradle --no-daemon desktop:dist -Pbuildversion=${buildVersion}
      gradle --no-daemon server:dist -Pbuildversion=${buildVersion}
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1kymfrd2vd23y1rmx19q47wc212r6qx03x6g58pxbqyylxmcw5zq";
  };

  # Separate commands for building and installing the server and the client
  buildClient = ''
    gradle --offline --no-daemon desktop:dist -Pbuildversion=${buildVersion}
  '';
  buildServer = ''
    gradle --offline --no-daemon server:dist -Pbuildversion=${buildVersion}
  '';
  installClient = ''
    install -Dm644 desktop/build/libs/Mindustry.jar $out/share/mindustry.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/mindustry \
      ${stdenv.lib.optionalString stdenv.isLinux "--prefix LD_LIBRARY_PATH : ${alsaLib}/lib"} \
      --add-flags "-jar $out/share/mindustry.jar"
    install -Dm644 core/assets/icons/icon_64.png $out/share/icons/hicolor/64x64/apps/mindustry.png
    install -Dm644 ${desktopItem}/share/applications/Mindustry.desktop $out/share/applications/Mindustry.desktop
  '';
  installServer = ''
    install -Dm644 server/build/libs/server-release.jar $out/share/mindustry-server.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/mindustry-server \
      --add-flags "-jar $out/share/mindustry-server.jar"
  '';

in
assert stdenv.lib.assertMsg (enableClient || enableServer)
  "mindustry: at least one of 'enableClient' and 'enableServer' must be true";
stdenv.mkDerivation rec {
  inherit pname version src postPatch;

  nativeBuildInputs = [ gradle_6 makeWrapper ];

  buildPhase = with stdenv.lib; ''
    ${preBuild}
    # point to offline repo
    sed -ie "s#mavenLocal()#mavenLocal(); maven { url '${deps}' }#g" build.gradle
    ${optionalString enableClient buildClient}
    ${optionalString enableServer buildServer}
  '';

  installPhase = with stdenv.lib; ''
    ${optionalString enableClient installClient}
    ${optionalString enableServer installServer}
  '';

  meta = with stdenv.lib; {
    homepage = "https://mindustrygame.github.io/";
    downloadPage = "https://github.com/Anuken/Mindustry/releases";
    description = "A sandbox tower defense game";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # Hash mismatch on darwin:
    # https://github.com/NixOS/nixpkgs/pull/105590#issuecomment-737120293
    # Problems with native libraries in aarch64:
    # https://github.com/NixOS/nixpkgs/pull/107646
    # https://logs.nix.ci/?key=nixos/nixpkgs.107646&attempt_id=3032c060-72e9-4a76-8186-4739544397dd
    broken = stdenv.isDarwin ||
             stdenv.isAarch64;
  };
}
