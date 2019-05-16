{ stdenv, fetchFromGitHub, jdk, jre, git, gradle_2_5, perl, makeWrapper, writeText }:

let
  name = "mxisd-${version}";
  version = "1.2.0";
  rev = "8c4ddd2e6526c1d2b284ba88cce3c2b926d99c62";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamax-matrix";
    repo = "mxisd";
    sha256 = "083plqg0rxsqwzyskin78wkmylhb7cqz37lpsa1zy56sxpdw1a3l";
  };


  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src;
    nativeBuildInputs = [ gradle_2_5 perl git ];

    buildPhase = ''
      export MXISD_BUILD_VERSION=${rev}
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
    outputHash = "0shshn05nzv23shry1xpcgvqg59gx929n0qngpfjhbq0kp7px68m";
  };

in
stdenv.mkDerivation {
  inherit name src version;
  nativeBuildInputs = [ gradle_2_5 perl makeWrapper ];
  buildInputs = [ jre ];

  patches = [ ./0001-gradle.patch ];

  buildPhase = ''
    export MXISD_BUILD_VERSION=${rev}
    export GRADLE_USER_HOME=$(mktemp -d)

    sed -ie "s#REPLACE#mavenLocal(); maven { url '${deps}' }#g" build.gradle
    gradle --offline --no-daemon build -x test
  '';

  installPhase = ''
    install -D build/libs/source.jar $out/lib/mxisd.jar
    makeWrapper ${jre}/bin/java $out/bin/mxisd --add-flags "-jar $out/lib/mxisd.jar"
  '';

  meta = with stdenv.lib; {
    description = "a federated matrix identity server";
    homepage = https://github.com/kamax-matrix/mxisd;
    license = licenses.agpl3;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };

}
