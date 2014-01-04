{ stdenv, fetchgit, autoconf, automake, libtool, glib, gtk3, dbus, pkgconfig, file, intltool, connman }:

stdenv.mkDerivation {
  name = "connmanui-b838e640eddb83d296fb6d146ce756066d37c43b";
  src = fetchgit {
    url = "git://github.com/tbursztyka/connman-ui.git";
    rev = "973879df2c4a556e5f49d808a88a6a5faba78c73";
    sha256 = "11ps52dn0ws978vv00yrymfvv534v1i9qqx5w93191qjcpjrwj6y";
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
