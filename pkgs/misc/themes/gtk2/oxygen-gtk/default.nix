{ stdenv, fetchurl,
  cmake, dbus_glib, glib, gtk, gdk_pixbuf, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  version = "1.4.5";
  name = "oxygen-gtk2-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-gtk2/${version}/src/${name}.tar.bz2";
    sha256 = "00ykq4aafakdkvww7kz84bvg9wc2gdji4m7z87f49hj1jxm84v2v";
  };

  buildInputs = [ cmake dbus_glib glib gtk gdk_pixbuf
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
