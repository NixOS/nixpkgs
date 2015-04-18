{ stdenv, fetchurl
, cmake, dbus_glib, glib, gtk3, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.4.1";
  name = "oxygen-gtk3-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk3/${version}/src/${name}.tar.bz2";
    sha256 = "0pd7wjzh5xgd24yg6b2avaiz1aq6rmh13d7c0jclffkmhmy24r0f";
  };

  buildInputs = [ cmake dbus_glib glib gtk3 gdk_pixbuf
   pkgconfig xorg.libXau xorg.libXdmcp xorg.libpthreadstubs
   xorg.libxcb xorg.pixman ];

  meta = with stdenv.lib; {
    description = "Port of the default KDE widget theme (Oxygen), to gtk 3";
    homepage = https://projects.kde.org/projects/playground/artwork/oxygen-gtk;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
