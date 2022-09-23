{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mssql-jdbc";
  version = "7.2.2";

  src = fetchurl {
    url = "https://github.com/Microsoft/mssql-jdbc/releases/download/v${version}/mssql-jdbc-${version}.jre8.jar";
    sha256 = "09psxjy1v3khq8lcq6h9mbgyijsgawf0z2qryk1l91ypnwl8s3pg";
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
