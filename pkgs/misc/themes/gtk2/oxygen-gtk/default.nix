{ stdenv, fetchurl,
  cmake, dbus_glib, glib, gtk, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.3.4";
  name = "oxygen-gtk2-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk2/${version}/src/${name}.tar.bz2";
    sha256 = "02q46kq0hhrmzwbjngg31ydl2198ls5bxgnz2si4amdmqii1nlmj";
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
