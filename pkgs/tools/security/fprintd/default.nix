{ stdenv, fetchurl, pkgconfig, libfprint, intltool, glib, dbus_glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  name = "fprintd-0.5.1";

  src = fetchurl {
    url = "http://people.freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "0n3fh28cvqrhjig30lz1p075g0wd7jnhvz1j34n37c0cwc7rfmlj";
  };

  patches = [ ./pod.patch ];

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
