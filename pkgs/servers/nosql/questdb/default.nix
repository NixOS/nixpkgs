{ fetchurl, jdk17_headless, lib, makeWrapper, stdenv }:

let
  jre = jdk17_headless;
in
stdenv.mkDerivation rec {
  pname = "questdb";
  version = "7.1.3";

  src = fetchurl {
    url = "https://github.com/questdb/questdb/releases/download/${version}/questdb-${version}-no-jre-bin.tar.gz";
    sha256 = "lB3h8HRQaQwdTtxxjHNfYrDXY3UULSSrM74OCGgLoMc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp questdb.sh $out/bin
    cp questdb.jar $out/share/java

    ln -s $out/share/java/questdb.jar $out/bin
    wrapProgram $out/bin/questdb.sh --set JAVA_HOME "${jre}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "high-performance, open-source SQL database for applications in financial services, IoT, machine learning, DevOps and observability";
    homepage = "https://questdb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.jacfal ];
    platforms = platforms.linux;
  };
}
