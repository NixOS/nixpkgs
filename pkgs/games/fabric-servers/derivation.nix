{
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  lib,

  jre,
  udev,

  version,
  url,
  hash,
}:

stdenvNoCC.mkDerivation (final: {
  pname = "fabric-server";
  inherit version;

  src = fetchurl {
    pname = "fabric-jar";
    inherit (final) version;

    inherit url hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/lib/fabric/server.jar

    makeWrapper ${lib.getExe jre} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/lib/fabric/server.jar nogui" \
      ${lib.optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  preferLocalBuild = true;

  passthru = {
    updateScript = ./update.py;
  };

  meta = {
    description = "Modular, lightweight mod loader for Minecraft";
    homepage = "https://fabricmc.net";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    inherit (jre.meta) platforms;
    maintainers = with lib.maintainers; [
      threadexio
    ];
    mainProgram = "minecraft-server";
  };
})
