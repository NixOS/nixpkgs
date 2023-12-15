{
  fetchurl,
  jdk17_headless,
  lib,
  makeBinaryWrapper,
  stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "questdb";
  version = "7.3.7";

  src = fetchurl {
    url = "https://github.com/questdb/questdb/releases/download/${finalAttrs.version}/questdb-${finalAttrs.version}-no-jre-bin.tar.gz";
    hash = "sha256-RvEYnPllmK7ZFJ5l4cmnVrRYr/EFpu5wSqsGzR2Y2K4=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp questdb.sh $out/bin
    cp questdb.jar $out/share/java

    ln -s $out/share/java/questdb.jar $out/bin
    wrapProgram $out/bin/questdb.sh --set JAVA_HOME "${jdk17_headless}"

    runHook postInstall
  '';

  meta = {
    description = "high-performance, open-source SQL database for applications in financial services, IoT, machine learning, DevOps and observability";
    homepage = "https://questdb.io/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jacfal ];
    platforms = lib.platforms.linux;
  };
})
