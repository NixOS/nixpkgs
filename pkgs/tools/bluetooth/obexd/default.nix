{ stdenv, fetchurl, pkgconfig, glib, dbus, openobex, bluez, libical }:
   
stdenv.mkDerivation rec {
  name = "obexd-0.27";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "17vlrhn1wgsbdd7f0ggw5nvs657miilhi5jc05pfmi4h18b8710l";
  };

  buildInputs = [ pkgconfig glib dbus.libs openobex bluez libical ];

  meta = {
    homepage = http://www.bluez.org/;
  };
}
