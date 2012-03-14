{ stdenv, fetchurl,
  cmake, dbus_glib, glib, gtk, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.1.1";
  name = "oxygen-gtk-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk/${version}/src/${name}.tar.bz2";
    sha256 = "66d571f08ec999f56de412f42a0395c9dc60b73adaaece96c6da6e98353fe379";
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
