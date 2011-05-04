{ stdenv, fetchurl, pkgconfig, libusb, glib, dbus_glib, bluez, openobex }:
   
stdenv.mkDerivation rec {
  name = "obex-data-server-0.4.6";
   
  src = fetchurl {
    url = "http://tadas.dailyda.com/software/${name}.tar.gz";
    sha256 = "0kq940wqs9j8qjnl58d6l3zhx0jaszci356xprx23l6nvdfld6dk";
  };

  buildInputs = [ pkgconfig libusb glib dbus_glib bluez openobex ];

  meta = {
    homepage = http://wiki.muiline.com/obex-data-server;
  };
}
