{ lib, fetchurl, appimageTools, gtk3 }:
let
  name = "saleae-logic-2";
  version = "2.3.37";
  src = fetchurl {
    url = "https://downloads.saleae.com/logic2/Logic-${version}-master.AppImage";
    sha256 = "0jclzd4s1r6h2p1r0vhmzz3jnwpp7d41g70lcamrsxidxrmm8d45";
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
