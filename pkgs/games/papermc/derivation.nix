{ lib, stdenvNoCC, fetchurl, makeBinaryWrapper, jre, version, hash, udev }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "papermc";
  inherit version hash;

  src =
    let
      version-split = lib.strings.splitString "-" finalAttrs.version;
      mcVersion = builtins.elemAt version-split 0;
      buildNum = builtins.elemAt version-split 1;
    in
    fetchurl {
      url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
      inherit (finalAttrs) hash;
    };

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/papermc/papermc.jar

    makeWrapper ${lib.getExe jre} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/papermc/papermc.jar nogui" \
      ${lib.optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  dontUnpack = true;
  preferLocalBuild = true;
  allowSubstitutes = false;

  passthru = {
    updateScript = ./update.py;
  };

  meta = {
    description = "High-performance Minecraft Server";
    homepage = "https://papermc.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aaronjanse neonfuz MayNiklas ];
    mainProgram = "minecraft-server";
  };
})
