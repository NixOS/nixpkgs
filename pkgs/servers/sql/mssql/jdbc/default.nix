{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mssql-jdbc";
  version = "12.2.0";

  src = fetchurl {
    url = "https://github.com/Microsoft/mssql-jdbc/releases/download/v${version}/mssql-jdbc-${version}.jre8.jar";
    sha256 = "sha256-Z0z9cDAF7TZ8IJr3Uh2xU0nK2+aNgerk5hO1kY+/wfY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp $src $out/share/java/mssql-jdbc.jar

    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.unix;
  };
}
