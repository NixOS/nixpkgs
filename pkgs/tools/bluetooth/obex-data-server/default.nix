{ stdenv, fetchurl, pkgconfig, libusb, glib, dbus-glib, bluez, openobex, dbus_libs }:
   
stdenv.mkDerivation rec {
  name = "obex-data-server-0.4.6";
   
  src = fetchurl {
    url = "http://tadas.dailyda.com/software/${name}.tar.gz";
    sha256 = "0kq940wqs9j8qjnl58d6l3zhx0jaszci356xprx23l6nvdfld6dk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb glib dbus-glib bluez openobex dbus_libs ];

  patches = [ ./obex-data-server-0.4.6-build-fixes-1.patch ];

  preConfigure = ''
  addToSearchPath PKG_CONFIG_PATH ${openobex}/lib64/pkgconfig
  export PKG_CONFIG_PATH="${dbus_libs.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  meta = {
    homepage = http://wiki.muiline.com/obex-data-server;
    platforms = stdenv.lib.platforms.linux;
  };
}
