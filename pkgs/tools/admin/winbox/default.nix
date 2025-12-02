{
  lib,
  stdenvNoCC,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  wine,
}:

let
  # The icon is also from the winbox AUR package (see above).
  icon = fetchurl {
    name = "winbox.png";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/winbox.png?h=winbox";
    hash = "sha256-YD6u2N+1thRnEsXO6AHm138fRda9XEtUX5+EGTg004A=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "winbox";
  version = "3.43";

  src = fetchurl (
    if (wine.meta.mainProgram == "wine64") then
      {
        url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/winbox64.exe";
        hash = "sha256-W0HPUf2B6NCCaH9rUiFZz0q6IubfjtxIZyHU4JUHtuk=";
      }
    else
      {
        url = "https://download.mikrotik.com/routeros/winbox/${finalAttrs.version}/winbox.exe";
        hash = "sha256-pAOOTgmjQoXI2o2MKTDuOOpb7q0rb/zWATDNyAMOLms=";
      }
  );

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,libexec,share/pixmaps}

    ln -s "${icon}" "$out/share/pixmaps/winbox.png"

    makeWrapper ${lib.getExe wine} $out/bin/winbox \
      --add-flags $src

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winbox";
      desktopName = "Winbox";
      comment = "GUI administration for Mikrotik RouterOS";
      exec = "winbox";
      icon = "winbox";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Graphical configuration utility for RouterOS-based devices";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    changelog = "https://wiki.mikrotik.com/wiki/Winbox_changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "winbox";
    maintainers = with lib.maintainers; [ yrd ];
  };
})
