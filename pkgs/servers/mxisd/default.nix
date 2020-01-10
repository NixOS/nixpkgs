{ stdenv, fetchFromGitHub, buildGradle, jre, makeWrapper }:

buildGradle rec {
  pname = "mxisd";
  version = "1.4.6";
  rev = "4a8867f9737d2089a2bc9bcdf9ead3204b97ebd6";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamax-matrix";
    repo = "mxisd";
    sha256 = "07gpdgbz281506p2431qn92bvdza6ap3jfq5b7xdm7nwrry80pzd";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];
  envSpec = ./gradle-env.json;
  gradleFlags = [ "shadowJar" ];

  preBuild = ''
    export MXISD_BUILD_VERSION=${rev}
    export GRADLE_USER_HOME=$(mktemp -d)
  '';

  installPhase = ''
    install -D build/libs/source.jar $out/lib/mxisd.jar
    makeWrapper ${jre}/bin/java $out/bin/mxisd --add-flags "-jar $out/lib/mxisd.jar"
  '';

  meta = with stdenv.lib; {
    description = "a federated matrix identity server";
    homepage = "https://github.com/kamax-matrix/mxisd";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };
}
