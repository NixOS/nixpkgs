{ thinkpad ? false
, stdenv, fetchurl, pkgconfig, intltool, libfprint-thinkpad ? null
, libfprint ? null, glib, dbus-glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  pname = "fprintd" + stdenv.lib.optionalString thinkpad "-thinkpad";
  version = "0.8.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/libfprint/fprintd/uploads/bdd9f91909f535368b7c21f72311704a/fprintd-${version}.tar.xz";
    sha256 = "124s0g9syvglgsmqnavp2a8c0zcq8cyaph8p8iyvbla11vfizs9l";
  };

  buildInputs = [ glib dbus-glib polkit nss pam systemd ]
    ++ stdenv.lib.optional thinkpad libfprint-thinkpad
    ++ stdenv.lib.optional (!thinkpad) libfprint;

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ 
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system" 
    "--localstatedir=/var" 
    "--sysconfdir=${placeholder "out"}/etc" 
  ];

  meta = with stdenv.lib; {
    homepage = https://fprint.freedesktop.org/;
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
