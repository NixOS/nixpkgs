{ stdenv, fetchFromGitHub, jre, git, gradle_5, perl, makeWrapper }:

let
  name = "ma1sd-${version}";
  version = "2.1.1";
  rev = "a112a5e57cb38ad282939d2dcb9c1476e038af39";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ma1uta";
    repo = "ma1sd";
    sha256 = "1qibn6m6mvxwnbiypxlgkaqg6in358vkf0q47410rv1dx1gjcnv5";
  };


  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src;
    nativeBuildInputs = [ gradle_5 perl git ];

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
    outputHash = "1w9cxq0rlzyh7bzqr3v3vn2cjhpn7hhc5lk9qzwj7sdj4jn2qxq6";
  };

in
stdenv.mkDerivation {
  inherit name src version;
  nativeBuildInputs = [ gradle_5 perl makeWrapper ];
  buildInputs = [ jre ];

  patches = [ ./0001-gradle.patch ];

  buildPhase = ''
    export MA1SD_BUILD_VERSION=${rev}
    export GRADLE_USER_HOME=$(mktemp -d)

    sed -ie "s#REPLACE#mavenLocal(); maven { url '${deps}' }#g" build.gradle
    gradle --offline --no-daemon build -x test
  '';

  installPhase = ''
    install -D build/libs/source.jar $out/lib/ma1sd.jar
    makeWrapper ${jre}/bin/java $out/bin/ma1sd --add-flags "-jar $out/lib/ma1sd.jar"
  '';

  meta = with stdenv.lib; {
    description = "a federated matrix identity server; fork of mxisd";
    homepage = "https://github.com/ma1uta/ma1sd";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };

}
