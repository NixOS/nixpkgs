{ lib, stdenv
, makeWrapper
, fetchFromGitLab
, gradle
, perl
, jre
, libpulseaudio
, makeDesktopItem
, copyDesktopItems
}:

let
  pname = "minosoft";
  version = "7ba4569"; # there are no tags yet, so lets version this using tags for now

  src = fetchFromGitLab {
    domain = "gitlab.bixilon.de";
    owner = "bixilon";
    repo = "minosoft";
    rev = "7ba45697e3586e0b6de231ed5db6d3e34cb37d82";
    hash = "sha256-sro49mh6c20HN1ZAHp5Ukzmn5IcniuLTa0w43S8ZVNw=";
    leaveDotGit = true; # needed by gradle scripts
  };

  # build jar into fixed-output derivation (it is fetching JARs to include from the internet anyways, so it doesnt matter if its not that conform to our ideals)
  deps = stdenv.mkDerivation {
    pname = "minosoft-deps";
    inherit version src;
    nativeBuildInputs = [ gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      # https://github.com/gradle/gradle/issues/4426
      ${lib.optionalString stdenv.isDarwin "export TERM=dumb"}
      gradle --no-daemon --info fatJar
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      #find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
      #  | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
      #  | sh
      cp -r . $out
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-yVlgw8zs1OD63xtCwaJpuYHr+LdxwXC0rfjR0ds7p5g=";
  };

  desktopItem = makeDesktopItem {
    name = "minosoft";
    desktopName = "Minosoft";
    comment = "An open source Minecraft re-implementation written from scratch";
    icon = "minosoft";
    exec = "minosoft";
    terminal = false;
    categories = [ "Game" "AdventureGame" ];
    keywords = [ "sandbox" "open" "source" "minecraft" ];
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ gradle perl makeWrapper copyDesktopItems ];

  desktopItems = [ desktopItem ];

  buildPhase = ''
    runHook preBuild
    ls
    echo ${deps}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/minosoft-fat*.jar $out/share/minosoft.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/minosoft \
      --prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib \
      --add-flags "-jar $out/share/minosoft.jar"

    install -Dm644 doc/img/Minosoft_logo.png \
      $out/share/pixmaps/minosoft.png

    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.bixilon.de/bixilon/minosoft";
    description = "An open source Minecraft re-implementation written from scratch";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aprl ];
    platforms = platforms.all;
    # https://github.com/NixOS/nixpkgs/pull/99885#issuecomment-740065005
    #broken = stdenv.isDarwin;
  };
}
