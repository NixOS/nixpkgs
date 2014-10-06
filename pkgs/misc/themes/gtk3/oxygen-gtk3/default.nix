{ stdenv, fetchurl
, cmake, dbus_glib, glib, gtk3, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "oxygen-gtk3-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk3/${version}/src/${name}.tar.bz2";
    sha256 = "d119bcc94ffc04b67e7d238fc922b37f2904447085a06758451b8c0b0302ab80";
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
