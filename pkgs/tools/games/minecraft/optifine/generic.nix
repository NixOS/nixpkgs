{
  version,
  sha256,
  lib,
  runCommand,
  fetchurl,
  makeWrapper,
  jre,
}:

let
  mcVersion = builtins.head (lib.splitString "_" version);
in
runCommand "optifine-${mcVersion}"
  {
    pname = "optifine";
    inherit version;

    src = fetchurl {
      url = "https://optifine.net/download?f=OptiFine_${version}.jar";
      inherit sha256;
      name = "OptiFine_${version}.jar";
    };

    nativeBuildInputs = [
      jre
      makeWrapper
    ];

    passthru.updateScript = {
      command = [ ./update.py ];
      supportedFeatures = [ "commit" ];
    };

    meta = {
      homepage = "https://optifine.net/";
      description = "Minecraft ${mcVersion} optimization mod";
      longDescription = ''
        OptiFine is a Minecraft optimization mod.
        It allows Minecraft to run faster and look better with full support for HD textures and many configuration options.
        This is for version ${mcVersion} of Minecraft.
      '';
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.unfree;
      maintainers = [ ];
      platforms = lib.platforms.unix;
      mainProgram = "optifine";
    };
  }
  ''
    mkdir -p $out/{bin,lib/optifine}
    cp $src $out/lib/optifine/optifine.jar

    makeWrapper ${jre}/bin/java $out/bin/optifine \
      --add-flags "-jar $out/lib/optifine/optifine.jar"
  ''
