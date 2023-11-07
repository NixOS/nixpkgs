{ lib
, stdenv
, makeDesktopItem
, fetchurl
, makeWrapper
, xorg
, jre
,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "runelite";
  version = "2.6.9";

  jar = fetchurl {
    url = "https://github.com/runelite/launcher/releases/download/${finalAttrs.version}/RuneLite.jar";
    hash = "sha256-91iBBviXM3tJN/jRgcOzUuTAr9VrKnW55uYrNW7eB5Q=";
  };

  icon = fetchurl {
    url = "https://github.com/runelite/launcher/raw/${finalAttrs.version}/appimage/runelite.png";
    hash = "sha256-gcts59jEuRVOmECrnSk40OYjTyJwSfAEys+Qck+VzBE=";
  };
  dontUnpack = true;

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = finalAttrs.icon;
    comment = "Open source Old School RuneScape client";
    desktopName = "RuneLite";
    genericName = "Oldschool Runescape";
    categories = [ "Game" ];
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/share/runelite
    mkdir -p $out/share/applications

    ln -s ${finalAttrs.jar} $out/share/runelite/RuneLite.jar
    ln -s ${finalAttrs.desktop}/share/applications/RuneLite.desktop $out/share/applications/RuneLite.desktop

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${xorg.libXxf86vm}/lib" \
      --add-flags "-jar $out/share/runelite/RuneLite.jar"
  '';

  meta = {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ kmeakin ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "runelite";
  };
})
