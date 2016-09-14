{ stdenv, fetchurl,
  cmake, dbus_glib, glib, gtk2, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.4.6";
  name = "oxygen-gtk2-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk2/${version}/src/${name}.tar.bz2";
    sha256 = "09mz4szsz3yswbj0nbw6qzlc5bc4id0f9r6ifm60b5nc8x1l72d2";
  };

  buildInputs = [ cmake dbus_glib glib gtk2 gdk_pixbuf
   pkgconfig xorg.libXau xorg.libXdmcp xorg.libpthreadstubs
   xorg.libxcb xorg.pixman ];

  meta = with stdenv.lib; {
    description = "Port of the default KDE widget theme (Oxygen), to gtk";
    homepage = https://projects.kde.org/projects/playground/artwork/oxygen-gtk;
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
