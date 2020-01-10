{ stdenv, fetchFromGitHub, buildGradle, jre, makeWrapper }:

buildGradle rec {
  pname = "ma1sd";
  version = "2.2.2";
  rev = "15db563e8dc7b692adf4d1c0cab9bfc3746b396e";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ma1uta";
    repo = "ma1sd";
    sha256 = "15g4pjp51y5ykkzwjzpfjbdm76h64sdc3xs6mhifymap3x34k3nr";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];
  envSpec = ./gradle-env.json;
  gradleFlags = [ "shadowJar" ];

  preBuild = ''
    export MA1SD_BUILD_VERSION=${rev}
    export GRADLE_USER_HOME=$(mktemp -d)
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
