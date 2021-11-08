{ lib, fetchurl, makeDesktopItem, appimageTools, gtk3 }:
let
  name = "saleae-logic-2";
  version = "2.3.39";
  src = fetchurl {
    url = "https://downloads.saleae.com/logic2/Logic-${version}-master.AppImage";
    sha256 = "1p31i8xillc5vrl2nli74b7p7cv2yz2qafp2gnyjfn0nbx5ij52g";
  };
  desktopItem = makeDesktopItem {
    inherit name;
    exec = name;
    icon = "Logic";
    comment = "Software for Saleae logic analyzers";
    desktopName = "Saleae Logic";
    genericName = "Logic analyzer";
    categories = "Development";
  };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit name src; };
    in
      ''
        mkdir -p $out/etc/udev/rules.d
        cp ${appimageContents}/resources/linux/99-SaleaeLogic.rules $out/etc/udev/rules.d/
        mkdir -p $out/share/pixmaps
        ln -s ${desktopItem}/share/applications $out/share/
        cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/Logic.png $out/share/pixmaps/Logic.png
      '';

  profile = ''
    export XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}''${XDG_DATA_DIRS:+:"''$XDG_DATA_DIRS"}"
  '';

  extraPkgs = pkgs: with pkgs; [
    wget
    unzip
    glib
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    nss
    nspr
    dbus
    gdk-pixbuf
    gtk3
    pango
    atk
    cairo
    expat
    xorg.libXrandr
    xorg.libXScrnSaver
    alsa-lib
    at-spi2-core
    cups
  ];

  meta = with lib; {
    homepage = "https://www.saleae.com/";
    description = "Software for Saleae logic analyzers";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.j-hui ];
  };
}
