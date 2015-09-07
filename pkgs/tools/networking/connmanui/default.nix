{ stdenv, fetchgit, autoconf, automake, libtool, glib, gtk3, dbus, pkgconfig, file, intltool, connman }:

stdenv.mkDerivation rec {
  name = "connmanui-${version}";
  rev = "fce0af94e121bde77c7fa2ebd6a319f0180c5516";
  version = "22062015-${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/tbursztyka/connman-ui.git";
    sha256 = "2072b337379b849cc55a19a3bb40834941e3f82b3924ef5d9b29e887fd19055e";
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
