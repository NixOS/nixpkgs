{ stdenv, fetchurl, appimageTools, gsettings-desktop-schemas, gtk3 }:

appimageTools.wrapType2 rec {
  name = "unityhub";

  extraPkgs = (pkgs: with pkgs; with xorg; [ gtk2 gdk_pixbuf glib libGL libGLU nss nspr
    alsaLib cups gnome2.GConf libcap fontconfig freetype pango
    cairo dbus dbus-glib libdbusmenu libdbusmenu-gtk2 expat zlib libpng12 udev tbb
    libpqxx gtk3 libsecret lsb-release openssl nodejs ncurses5

    libX11 libXcursor libXdamage libXfixes libXrender libXi
    libXcomposite libXext libXrandr libXtst libSM libICE libxcb ]);

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  src = fetchurl {
    url = "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage";
    sha256 = "1rx7ih94ig3pd1yx1d3fpx7zpixq3j5birkpnzkh778qqsdrg0nf";
  };

  meta = with stdenv.lib; {
    homepage = https://unity3d.com/;
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tesq0 ];
  };
}
