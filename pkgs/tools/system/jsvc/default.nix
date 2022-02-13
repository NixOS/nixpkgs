{ lib, stdenv, fetchurl, commonsDaemon, jdk, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "jsvc";
  version = "1.2.4";

  src = fetchurl {
    url = "https://downloads.apache.org//commons/daemon/source/commons-daemon-${version}-src.tar.gz";
    sha256 = "1nrr6ggy6h20r9zyv14vx6vc9p1w6l8fl9fn6i8dx2hrq6kk2bjw";
  };

  buildInputs = [ commonsDaemon ];
  nativeBuildInputs = [ jdk makeWrapper ];

  preConfigure = ''
    cd ./src/native/unix/
    sh ./support/buildconf.sh
  '';

  preBuild = ''
    export JAVA_HOME=${jre}
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp jsvc $out/bin/jsvc
    chmod +x $out/bin/jsvc
    wrapProgram $out/bin/jsvc --set JAVA_HOME "${jre}"
    runHook postInstall
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-daemon";
    description = "JSVC is part of the Apache Commons Daemon software, a set of utilities and Java support classes for running Java applications as server processes.";
    maintainers = with lib.maintainers; [ rsynnest ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
