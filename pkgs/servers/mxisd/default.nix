{ stdenv, fetchFromGitHub, jre, git, gradle_4_10, perl, makeWrapper }:

let
  name = "mxisd-${version}";
  version = "1.4.5";
  rev = "a964b073bfa7552e94fe51f48e18830b1051b0b7";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamax-matrix";
    repo = "mxisd";
    sha256 = "1h1lx531rjswh0m2zdsmfizrkkx9bh414v9m321hbbfzk3f98fkk";
  };


  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src;
    nativeBuildInputs = [ gradle_4_10 perl git ];

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
    outputHash = "0z9f3w7lfdvbk26kyckpbgas7mi98rjghck9w0kvx3r7k48p5vnv";
  };

in
stdenv.mkDerivation {
  inherit name src version;
  nativeBuildInputs = [ gradle_4_10 perl makeWrapper ];
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
