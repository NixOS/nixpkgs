{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchzip,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  libGL,
  libz,
  freetype,
  fontconfig,
  libxkbcommon,
  xorg,
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
  version = "4.0beta4";

  src = fetchzip {
    url = "https://download.mikrotik.com/routeros/winbox/4.0beta4/WinBox_Linux.zip";
    sha256 = "sha256-AW0k5v60qIaQElypQhRpD0AVigOh2lR5YReT697H4ko=";
    stripRoot = false;
  };

  buildInputs = [
    libGL # libGL.so.1, libEGL.so.1
    libz # libz.so.1
    fontconfig
    freetype # libfreetype.so.6
    libxkbcommon # libxkbcommon.so.0 libxkbcommon-x11.so.0 libxcb-icccm.so.4 libxcb-image.so.0 libxcb-keysyms.so.1 libxcb-randr.so.0 libxcb-render-util.so.0
    xorg.xcbutilwm # libxcb-icccm.so.4
    xorg.xcbutilimage # libxcb-image.so.0
    xorg.xcbutilkeysyms # libxcb-keysyms.so.1
    xorg.xcbutilrenderutil # libxcb-render-util.so.0
  ];

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/pixmaps}

    ln -s "${icon}" "$out/share/pixmaps/winbox.png"

    cp -v "WinBox" "$out/bin/"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "winbox";
      desktopName = "Winbox";
      comment = "GUI administration for Mikrotik RouterOS";
      exec = "WinBox";
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
