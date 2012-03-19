{ stdenv, fetchurl, polkit, gtk3, pkgconfig, intltool }:

stdenv.mkDerivation {
  name = "polkit-gnome-0.105";

  src = fetchurl {
    url = mirror://gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz;
    sha256 = "0sckmcbxyj6sbrnfc5p5lnw27ccghsid6v6wxq09mgxqcd4lk10p";
  };

  buildInputs = [ polkit gtk3 ];
  buildNativeInputs = [ pkgconfig intltool ];

  configureFlags = "--disable-introspection";

  # Desktop file from Debian
  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    substituteAll ${./polkit-gnome-authentication-agent-1.desktop} $out/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop
    '';

  meta = {
    homepage = http://hal.freedesktop.org/docs/PolicyKit/;
    description = "A dbus session bus service that is used to bring up authentication dialogs";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom ];
  };
}
