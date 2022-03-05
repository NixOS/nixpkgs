{ lib
, stdenv
, fetchurl
, makeDesktopItem
, makeWrapper
, symlinkJoin
, writeShellScriptBin

, wine
, use64 ? false
}:

let
  inherit (lib) last splitString;

  pname = "winbox";
  version = "3.35";
  name = "${pname}-${version}";

  executable = fetchurl (if use64 then {
    url = "https://download.mikrotik.com/winbox/${version}/${pname}64.exe";
    sha256 = "0jigjs4paci6h897hl1046ks5f812jfb2ihnp78lbah0294shjnj";
  } else {
    url = "https://download.mikrotik.com/winbox/${version}/${pname}.exe";
    sha256 = "1a3cjhvh2z4n767aqqkv3a7wlda34ssgx9acigdcszgvbksbav1f";
  });
  # This is from the winbox AUR package:
  # https://aur.archlinux.org/cgit/aur.git/tree/winbox64?h=winbox64&id=8edd93792af84e87592e8645ca09e9795931e60e
  wrapper = writeShellScriptBin pname ''
    export WINEPREFIX="''${WINBOX_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/winbox"}/wine"
    export WINEARCH=${if use64 then "win64" else "win32"}
    export WINEDLLOVERRIDES="mscoree=" # disable mono
    export WINEDEBUG=-all
    if [ ! -d "$WINEPREFIX" ] ; then
      mkdir -p "$WINEPREFIX"
      ${wine}/bin/wineboot -u
    fi

    ${wine}/bin/wine ${executable} "$@"
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Winbox";
    comment = "GUI administration for Mikrotik RouterOS";
    exec = pname;
    icon = pname;
    categories = [ "Utility" ];
    startupWMClass = last (splitString "/" executable);
  };

  # The icon is also from the winbox AUR package (see above).
  icon = fetchurl {
    name = "winbox.png";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/winbox.png?h=winbox";
    sha256 = "sha256-YD6u2N+1thRnEsXO6AHm138fRda9XEtUX5+EGTg004A=";
  };
in
symlinkJoin {
  inherit name pname version;
  paths = [ wrapper desktopItem ];

  postBuild = ''
    mkdir -p "$out/share/pixmaps"
    ln -s "${icon}" "$out/share/pixmaps/${pname}.png"
  '';

  meta = with lib; {
    description = "Graphical configuration utility for RouterOS-based devices";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    changelog = "https://wiki.mikrotik.com/wiki/Winbox_changelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yrd ];
  };
}
