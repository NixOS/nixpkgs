{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mssql-jdbc";
  version = "12.6.3";

  src = fetchurl {
    url = "https://github.com/Microsoft/mssql-jdbc/releases/download/v${version}/mssql-jdbc-${version}.jre8.jar";
    sha256 = "sha256-Q5XwJ3j6J06DjX2tIVM676tXvKSrBb0W6/EucHpyTI4=";
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
