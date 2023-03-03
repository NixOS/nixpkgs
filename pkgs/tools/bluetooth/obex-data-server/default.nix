{ lib, stdenv, fetchurl, pkg-config, libusb-compat-0_1, glib, dbus-glib, bluez, openobex, dbus }:

stdenv.mkDerivation rec {
  pname = "obex-data-server";
  version = "0.4.6";

  src = fetchurl {
    url = "http://tadas.dailyda.com/software/obex-data-server-${version}.tar.gz";
    sha256 = "0kq940wqs9j8qjnl58d6l3zhx0jaszci356xprx23l6nvdfld6dk";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    dbus-glib # required for dbus-binding-tool
  ];
  buildInputs = [ libusb-compat-0_1 glib dbus-glib bluez openobex dbus ];

  patches = [ ./obex-data-server-0.4.6-build-fixes-1.patch ];

  preConfigure = ''
  addToSearchPath PKG_CONFIG_PATH ${openobex}/lib64/pkgconfig
  export PKG_CONFIG_PATH="${dbus.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  meta = with lib; {
    homepage = "http://wiki.muiline.com/obex-data-server";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
