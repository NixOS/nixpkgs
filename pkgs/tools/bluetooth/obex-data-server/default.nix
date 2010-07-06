{ stdenv, fetchurl, pkgconfig, libusb, glib, dbus_glib, bluez, openobex }:
   
stdenv.mkDerivation rec {
  name = "obex-data-server-0.4.5";
   
  src = fetchurl {
    url = "http://tadas.dailyda.com/software/${name}.tar.gz";
    sha256 = "0qy7mrwr3xfplcxlrq97hiiyda7r9jn24015y9azahi7q5xjfhg7";
  };

  buildInputs = [ pkgconfig libusb glib dbus_glib bluez openobex ];

  meta = {
    homepage = http://wiki.muiline.com/obex-data-server;
  };
}
