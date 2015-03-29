{ stdenv, fetchurl, pkgconfig, intltool
, libfprint, glib, dbus_glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  name = "fprintd-0.6.0";

  src = fetchurl {
    url = "http://people.freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "1by6nvlrqkwzcz2v2kyq6avi3h384vmlr42vj9s2yzcinkp64m1z";
  };

  buildInputs = [ libfprint glib dbus_glib polkit nss pam systemd ];
  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/lib/systemd/system" ];

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/fprint/fprintd/";
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
