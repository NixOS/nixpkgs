{ lib, stdenv, fetchFromGitHub, jre, git, gradle_6, perl, makeWrapper }:

let
  pname = "ma1sd";
  version = "2.4.0";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "ma1uta";
    repo = "ma1sd";
    hash = "sha256-8UnhrGa8KKmMAAkzUXztMkxgYOX8MU1ioXuEStGi4Vc=";
  };


  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;
    nativeBuildInputs = [ gradle_6 perl git ];

    buildPhase = ''
      export MA1SD_BUILD_VERSION=${rev}
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon build -x test
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    dontStrip = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0x2wmmhjgnb6p72d3kvnv2vg52l0c4151rs4jrazs9rvxjfc88dr";
  };

in
stdenv.mkDerivation {
  inherit pname src version;
  nativeBuildInputs = [ gradle_6 perl makeWrapper ];
  buildInputs = [ jre ];

  buildPhase = ''
    runHook preBuild
    export MA1SD_BUILD_VERSION=${rev}
    export GRADLE_USER_HOME=$(mktemp -d)

    sed -ie "s#jcenter()#mavenLocal(); maven { url '${deps}' }#g" build.gradle
    gradle --offline --no-daemon build -x test
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D build/libs/source.jar $out/lib/ma1sd.jar
    makeWrapper ${jre}/bin/java $out/bin/ma1sd --add-flags "-jar $out/lib/ma1sd.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "a federated matrix identity server; fork of mxisd";
    homepage = "https://github.com/ma1uta/ma1sd";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };

}
