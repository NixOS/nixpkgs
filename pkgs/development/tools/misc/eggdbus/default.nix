{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus-glib }:

stdenv.mkDerivation rec {
  name = "eggdbus-0.6";

  src = fetchurl {
    url = "https://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "118hj63ac65zlg71kydv4607qcg1qpdlql4kvhnwnnhar421jnq4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib dbus dbus-glib ];

  meta = with stdenv.lib; {
    homepage = https://hal.freedesktop.org/releases/;
    description = "D-Bus bindings for GObject";
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
