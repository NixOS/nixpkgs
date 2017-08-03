{ stdenv, fetchurl, pkgconfig, autoconf, automake, m4
, intltool, glib, libsoup, gdk_pixbuf }:

stdenv.mkDerivation rec {
  version = "0_1_7";
  name = "appdata_tools-${version}";

  src = fetchurl {
    url = "https://github.com/hughsie/appdata-tools/archive/appdata_tools_${version}.tar.gz";
    sha256 = "1bzqg4gy8gqhbk2qjizsm0b78li9mv84fb3d8qwfpxh7c7p360x8";
  };

  buildInputs = [ pkgconfig autoconf automake m4 intltool glib
                  libsoup gdk_pixbuf ];

  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = http://people.freedesktop.org/~hughsient/appdata;
    description = "CLI designed to validate AppData descriptions for standards compliance and to the style guide";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ lethalman ];
  };
}
