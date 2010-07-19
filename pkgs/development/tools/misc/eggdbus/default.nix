{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, zlib }:

stdenv.mkDerivation rec {
  name = "eggdbus-0.6";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "118hj63ac65zlg71kydv4607qcg1qpdlql4kvhnwnnhar421jnq4";
  };
  
  buildInputs = [ pkgconfig glib dbus.libs dbus_glib zlib ];

  meta = {
    homepage = http://hal.freedesktop.org/releases/;
    description = "D-Bus bindings for GObject";
  };
}
