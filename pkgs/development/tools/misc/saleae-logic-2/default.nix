{ lib, fetchurl, makeDesktopItem, appimageTools }:
let
  name = "saleae-logic-2";
  version = "2.3.58";
  src = fetchurl {
    url = "https://downloads.saleae.com/logic2/Logic-${version}-master.AppImage";
    sha256 = "sha256-WQa9J+rK71+T2IFUVpPLjkYfHy9GmZ9DZTBo+U4JKfo=";
  };
  desktopItem = makeDesktopItem {
    inherit name;
    exec = name;
    icon = "Logic";
    comment = "Software for Saleae logic analyzers";
    desktopName = "Saleae Logic";
    genericName = "Logic analyzer";
    categories = [ "Development" ];
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
    maintainers = with maintainers; [ j-hui newam ];
  };
}
