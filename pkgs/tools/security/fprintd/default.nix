{ stdenv, fetchurl, pkgconfig, intltool
, libfprint, glib, dbus-glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  name = "fprintd-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "https://people.freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "00i21ycaya4x2qf94mys6s94xnbj5cfm8zhhd5sc91lvqjk4r99k";
  };

  buildInputs = [ libfprint glib dbus-glib polkit nss pam systemd ];
  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/lib/systemd/system" "--localstatedir=/var" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/fprint/fprintd/;
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
