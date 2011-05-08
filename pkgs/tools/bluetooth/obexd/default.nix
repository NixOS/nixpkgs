{ stdenv, fetchurl, pkgconfig, glib, dbus, openobex, bluez, libical }:
   
stdenv.mkDerivation rec {
  name = "obexd-0.40";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "0jz0ldg2wvdzzl639xzf76hqwj23svlg3zv1r8nc3hik3pgs6h2l";
  };

  buildInputs = [ glib dbus.libs openobex bluez libical ];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.bluez.org/;
  };
}
