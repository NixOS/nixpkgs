{ stdenv
, makeWrapper
, fetchFromGitHub
, gradle_5
, perl
, jre
, libpulseaudio
}:

let
  pname = "shattered-pixel-dungeon";
  version = "0.8.1a";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
    rev = "v${version}";
    sha256 = "0cfrcjvnn2j4p7zbz252qbn2jacgwhzaja8lqvif0x1vszyl41v7";
  };

  postPatch = ''
    # disable gradle plugins with native code and their targets
    perl -i.bak1 -pe "s#(^\s*id '.+' version '.+'$)#// \1#" build.gradle
    perl -i.bak2 -pe "s#(.*)#// \1# if /^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar)/ ... /^}/" build.gradle
    # Remove unbuildable android stuff
    rm android/build.gradle
  '';

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src postPatch;
    nativeBuildInputs = [ gradle_5 perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon desktop:release
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0ih10c6c85vhrqgilqmkzqjx3dc8cscvs9wkh90zgdj10qv0iba3";
  };

in stdenv.mkDerivation rec {
  inherit pname version src postPatch;

  nativeBuildInputs = [ gradle_5 perl makeWrapper ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    # point to offline repo
    sed -ie "s#repositories {#repositories { maven { url '${deps}' };#g" build.gradle
    gradle --offline --no-daemon desktop:release
  '';

  installPhase = ''
    install -Dm644 desktop/build/libs/desktop-${version}.jar $out/share/shattered-pixel-dungeon.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/shattered-pixel-dungeon \
      --prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib \
      --add-flags "-jar $out/share/shattered-pixel-dungeon.jar"
  '';

  meta = with stdenv.lib; {
    homepage = "https://shatteredpixel.com/";
    downloadPage = "https://github.com/00-Evan/shattered-pixel-dungeon/releases";
    description = "Traditional roguelike game with pixel-art graphics and simple interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

