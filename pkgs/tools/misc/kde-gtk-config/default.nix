{ stdenv, fetchurl, cmake, gettext, gtk2, gtk3, kdelibs
, libxcb, libpthreadstubs, libXdmcp, pkgconfig, glib, gdk_pixbuf }:

stdenv.mkDerivation {
  name = "kde-gtk-config-2.2.1";
  src = fetchurl {
    url = "mirror://kde/stable/kde-gtk-config/2.2.1/src/kde-gtk-config-2.2.1.tar.xz";
    sha256 = "11aw86jcjcg3ywnzrxy9x8dvd73my18k0if52fnvyvmb75z0v2cw";
  };

  buildInputs = [
    cmake
    gdk_pixbuf
    gettext
    glib
    gtk2
    gtk3
    kdelibs
    libxcb
    libpthreadstubs
    libXdmcp
    pkgconfig
  ];

  patches = [ ./kde-gtk-config-2.2.1-install-paths.patch ];

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2}/include/gtk-2.0
    -DKDE4_LIBEXEC_INSTALL_DIR=lib/kde4/libexec
  '';

  meta = with stdenv.lib; {
    homepage = https://projects.kde.org/projects/extragear/base/kde-gtk-config;
    description = "GTK configuration module for KDE System Settings";
    longDescription = ''
      Configuration dialog to adapt GTK applications appearance to your taste under KDE.
      Among its many features, it lets you:
      - Choose which theme is used for GTK2 and GTK3 applications.
      - Tweak some GTK applications behaviour.
      - Select what icon theme to use in GTK applications.
      - Select GTK applications default fonts.
      - Easily browse and install new GTK2 and GTK3 themes.
    '';
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.ttuegel ];
  };
}
