{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib }:

stdenv.mkDerivation rec {
  name = "eggdbus-0.5";
  
  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0g1s9nzfyjyhnmv4hzll3izayh4c4pjy3i51ihwgkz3wmd1xaq9j";
  };
  
  buildInputs = [ pkgconfig glib dbus.libs dbus_glib ];

  meta = {
    homepage = http://hal.freedesktop.org/releases/;
    description = "D-Bus bindings for GObject";
  };
}
