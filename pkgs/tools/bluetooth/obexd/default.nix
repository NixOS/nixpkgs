{ stdenv, fetchurl, pkgconfig, glib, dbus, openobex, bluez, libical }:
   
stdenv.mkDerivation rec {
  name = "obexd-0.47";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "15zw008098qr5az9y1c010yv8gkw1f6hi3mnfcvpmwxwh23kfh4i";
  };

  buildInputs = [ glib dbus.libs openobex bluez libical ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.bluez.org/;
  };
}
