{ stdenv, fetchurl, pkgconfig, glib, dbus, openobex, bluez }:
   
stdenv.mkDerivation rec {
  name = "obexd-0.18";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "0a3jpkgg8skiqmy2ksfffmwysji4dnd4h9fc46nj0wcn8n9vvfkd";
  };

  buildInputs = [ pkgconfig glib dbus.libs openobex bluez ];

  meta = {
    homepage = http://www.bluez.org/;
  };
}
