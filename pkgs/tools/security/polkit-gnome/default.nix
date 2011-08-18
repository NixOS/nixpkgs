{ stdenv, fetchurl, pkgconfig, gtk, polkit, dbus_glib, intltool }:
stdenv.mkDerivation rec {

  name = "polkit-gnome-${version}";
  version = "0.96";

  src = fetchurl {
    url = http://hal.freedesktop.org/releases/polkit-gnome-0.96.tar.bz2;
    sha256 = "14la7j3h1k1s88amkcv8rzq9wmhgzypvxpwaxwg2x2k55l1wi5hd";
  };

  buildInputs = [ pkgconfig gtk polkit dbus_glib intltool ];

  configureFlags = [ "--disable-introspection" ];

  meta = with stdenv.lib; {
    homepage = http://hal.freedesktop.org/docs/PolicyKit/;
    description = "A dbus session bus service that is used to bring up authentication dialogs";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
  };
}