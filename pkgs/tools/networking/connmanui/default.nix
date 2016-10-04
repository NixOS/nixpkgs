{ stdenv, fetchgit, autoconf, automake, libtool, glib, gtk3, dbus, pkgconfig, file, intltool, connman }:

stdenv.mkDerivation rec {
  name = "connmanui-${version}";
  rev = "fce0af94e121bde77c7fa2ebd6a319f0180c5516";
  version = "22062015-${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/tbursztyka/connman-ui.git";
    sha256 = "0ixx8c9cfdp480z21xfjb7n1x27sf1g8gmgbmcfhr0k888dmziyy";
  };

  buildInputs = [ autoconf automake libtool glib gtk3 dbus pkgconfig file intltool connman ];

  preConfigure = ''
    rm m4/intltool.m4
    ln -s ${intltool}/share/aclocal/intltool.m4 m4/
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
