{ stdenv, fetchgit, autoconf, automake, libtool, glib, gtk3, dbus, pkgconfig, file, intltool, connman }:

stdenv.mkDerivation {
  name = "connmanui-b838e640eddb83d296fb6d146ce756066d37c43b";
  src = fetchgit {
    url = "git://github.com/tbursztyka/connman-ui.git";
    rev = "e4a8ddcca0870eb2ece5a7e3ea0296de9c86e5b2";
    sha256 = "0rml52v81s7hr0g6qbj5bamli08kn66hay84qicx8sy8679wg443";
  };

  buildInputs = [ autoconf automake libtool glib gtk3 dbus pkgconfig file intltool connman ];

  preConfigure = ''
    set -e
    ./autogen.sh
    sed -i "s/\/usr\/bin\/file/file/g" ./configure
  '';

  configureScript = "./configure";

  meta = {
    description = "A full-featured GTK based trayicon UI for ConnMan";
    homepage = "https://github.com/tbursztyka/connman-ui";
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
