{ stdenv, fetchurl, pkgconfig, intltool
, libfprint, glib, dbus_glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  name = "fprintd-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "http://people.freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "05915i0bv7q62fqrs5diqwr8dz3pwqa1c1ivcgggkjyw0xk4ldp5";
  };

  buildInputs = [ libfprint glib dbus_glib polkit nss pam systemd ];
  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/lib/systemd/system" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/fprint/fprintd/;
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
