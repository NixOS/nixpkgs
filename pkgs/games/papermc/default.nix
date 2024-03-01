{
  lib,
  stdenvNoCC,
  fetchurl,
  jre,
  makeBinaryWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "papermc";
  version = "1.20.4.435";

  src =
    let
      mcVersion = lib.versions.pad 3 finalAttrs.version;
      buildNum = builtins.elemAt (lib.splitVersion finalAttrs.version) 3;
    in
    fetchurl {
      url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
      hash = "sha256-NrIsYLoAAWORw/S26NDFjYBVwpNITJxuWGZow3696wM=";
    };

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/papermc/papermc.jar

    makeWrapper ${lib.getExe jre} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/papermc/papermc.jar nogui"

    runHook postInstall
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  dontUnpack = true;
  preferLocalBuild = true;
  allowSubstitutes = false;

  meta = {
    description = "High-performance Minecraft Server";
    homepage = "https://papermc.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aaronjanse neonfuz ];
    mainProgram = "minecraft-server";
  };
})
