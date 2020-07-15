{ stdenv, fetchFromGitHub, gradle, jdk }:

let
  pname = "structurizr-cli";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "structurizr";
    repo = "cli";
    rev = "v${version}";
    sha256 = "113pkdasdymm4cah92d51ddhk4n3sczh8hb6z97bd3rb1pv55zl1";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src version;

    nativeBuildInputs = [ gradle jdk ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon bootJar
    '';

    installPhase = ''
        mkdir -p $out/modules-2
        cp -R $GRADLE_USER_HOME/caches/modules-2 $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1yrj33j70vmd84n3yc4l3wxz9b2p7bimq6hw94s7sih1a7zac3pn";
  };

in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ gradle jdk ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    export GRADLE_RO_DEP_CACHE=${deps}
    echo $GRADLE_RO_DEP_CACHE
    gradle --offline --no-daemon --info bootJar
  '';

  installPhase = ''
    mkdir $out $out/bin
    cp build/libs/structurizr-cli-${version}.jar $out/bin
    cp etc/structurizr.sh $out/bin/structurizr
  '';

  meta = with stdenv.lib; {
    description = "Command line tool for Structurizr";
    longDescription = ''
      A command line utility for Structurizr, which supports pushing and pulling from a
      Structurizr workspace, and exporting diagrams to PlantUML, Mermaid, and WebSequenceDiagrams
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mgdm ];
  };
}
