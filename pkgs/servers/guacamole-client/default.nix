{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "guacamole-client";
  version = "1.5.4";

  src = fetchurl {
    url = "https://archive.apache.org/dist/guacamole/${finalAttrs.version}/binary/guacamole-${finalAttrs.version}.war";
    hash = "sha256-Vyi1Y5Eb1kvOCguBx06ozLIZDReFv/NAMPxohagnPT4=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/webapps
    cp $src $out/webapps/guacamole.war

    runHook postInstall
  '';

  meta = {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.apache.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.drupol ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    sourceProvenance = [
      lib.sourceTypes.binaryBytecode
    ];
  };
})
