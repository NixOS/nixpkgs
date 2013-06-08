{ stdenv, fetchurl,
  cmake, dbus_glib, glib, gtk, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.3.2.1";
  name = "oxygen-gtk2-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk2/${version}/src/${name}.tar.bz2";
    sha256 = "19l0dhjswvm7y99pvbd3qnz37k0p5y2slljy8mm4r8awjff3v4qi";
  };

  buildInputs = [ cmake dbus_glib glib gtk gdk_pixbuf
   pkgconfig xorg.libXau xorg.libXdmcp xorg.libpthreadstubs
   xorg.libxcb xorg.pixman ];

  meta = with stdenv.lib; {
    description = "Port of the default KDE widget theme (Oxygen), to gtk";
    homepage = https://projects.kde.org/projects/playground/artwork/oxygen-gtk;
    license = licenses.lgpl2;
    maintainers = [ maintainers.goibhniu ];
  };
}
