{ lib
, stdenvNoCC
, fetchurl
, nixosTests
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "guacamole-client";
  version = "1.5.3";

  src = fetchurl {
    url = "https://archive.apache.org/dist/guacamole/${finalAttrs.version}/binary/guacamole-${finalAttrs.version}.war";
    hash = "sha256-FaNObtbPbwP+IPkPZ9LWCXE6ic08syT4nt8edpbm7WE=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/webapps
    cp $src $out/webapps/guacamole.war

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) guacamole-client;
  };

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
