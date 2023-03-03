{ lib, stdenv, runtimeShell, writeText, fetchFromGitHub, gradle, openjdk17, git, perl, cmake }:
let
  pname = "fastddsgen";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS-Gen";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-lxMv1hXjHFslJts63/FJPjj0mAKTluY/pNTvf15Oo9o=";
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;
    nativeBuildInputs = [ gradle openjdk17 perl ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon -x submodulesUpdate assemble
    '';

    # perl code mavenizes paths (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    dontStrip = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-wnnoyaO1QndAYrqmYu1fO6OJrP1NQs8IX4uh37dVntY=";
  };
in
stdenv.mkDerivation {
  inherit pname src version;

  nativeBuildInputs = [ gradle openjdk17 ];

  # use our offline deps
  postPatch = ''
    sed -ie '1i\
    pluginManagement {\
      repositories {\
        maven { url "${deps}" }\
      }\
    }' thirdparty/idl-parser/settings.gradle
    sed -ie "s#mavenCentral()#maven { url '${deps}' }#g" build.gradle
    sed -ie "s#mavenCentral()#maven { url '${deps}' }#g" thirdparty/idl-parser/build.gradle
  '';

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)

    # Run gradle with daemon to make installPhase faster
    gradle --offline -x submodulesUpdate assemble

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    gradle --offline -x submodulesUpdate install --install_path=$out

    # Override the default start script to use absolute java path
    cat  <<EOF >$out/bin/fastddsgen
    #!${runtimeShell}
    exec ${openjdk17}/bin/java -jar "$out/share/fastddsgen/java/fastddsgen.jar" "\$@"
    EOF
    chmod a+x "$out/bin/fastddsgen"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast-DDS IDL code generator tool";
    homepage = "https://github.com/eProsima/Fast-DDS-Gen";
    license = licenses.asl20;
    longDescription = ''
      eProsima Fast DDS-Gen is a Java application that generates
      eProsima Fast DDS C++ or Python source code using the data types
      defined in an IDL (Interface Definition Language) file. This
      generated source code can be used in any Fast DDS application in
      order to define the data type of a topic, which will later be
      used to publish or subscribe.
    '';
    maintainers = with maintainers; [ wentasah ];
    platforms = openjdk17.meta.platforms;
  };
}
