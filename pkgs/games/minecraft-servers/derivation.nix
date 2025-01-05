{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  jre_headless,
  makeWrapper,
  udev,
  version,
  url,
  sha1,
}:
stdenv.mkDerivation {
  pname = "minecraft-server";
  inherit version;

  src = fetchurl { inherit url sha1; };

  preferLocalBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/lib/minecraft/server.jar

    makeWrapper ${lib.getExe jre_headless} $out/bin/minecraft-server \
      --append-flags "-jar $out/lib/minecraft/server.jar nogui" \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  dontUnpack = true;

  passthru = {
    tests = { inherit (nixosTests) minecraft-server; };
    updateScript = ./update.py;
  };

  meta = with lib; {
    description = "Minecraft Server";
    homepage = "https://minecraft.net";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      tomberek
      costrouc
    ];
  };
}
