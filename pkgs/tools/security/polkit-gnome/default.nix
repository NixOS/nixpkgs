{ stdenv, fetchurl, polkit, gtk3, pkgconfig, intltool }:
stdenv.mkDerivation rec {
  pname = "polkit-gnome";
  version = "0.105";

  src = fetchurl {
    url = "mirror://gnome/sources/polkit-gnome/${version}/${pname}-${version}.tar.xz";
    sha256 = "0sckmcbxyj6sbrnfc5p5lnw27ccghsid6v6wxq09mgxqcd4lk10p";
  };

  buildInputs = [ polkit gtk3 ];
  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--disable-introspection" ];

  # Desktop file from Debian
  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    substituteAll ${./polkit-gnome-authentication-agent-1.desktop} $out/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/Archive/policykit-gnome";
    description = "A dbus session bus service that is used to bring up authentication dialogs";
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ phreedom ];
    platforms = stdenv.lib.platforms.linux;
  };
}
