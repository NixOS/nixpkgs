{ stdenv, fetchurl, pkgconfig, intltool
, libfprint, glib, dbus-glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  name = "fprintd-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/libfprint/fprintd/uploads/bdd9f91909f535368b7c21f72311704a/fprintd-${version}.tar.xz";
    sha256 = "124s0g9syvglgsmqnavp2a8c0zcq8cyaph8p8iyvbla11vfizs9l";
  };

  buildInputs = [ libfprint glib dbus-glib polkit nss pam systemd ];
  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/lib/systemd/system" "--localstatedir=/var" ];

  meta = with stdenv.lib; {
    homepage = https://fprint.freedesktop.org/;
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
