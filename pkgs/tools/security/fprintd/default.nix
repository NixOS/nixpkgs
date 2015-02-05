{ stdenv, fetchgit, automake, autoconf, libtool, pkgconfig, gtk_doc
, libfprint, intltool, glib, dbus_glib, polkit, nss, pam, systemd }:

stdenv.mkDerivation rec {
  name = "fprintd";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/libfprint/fprintd";
    rev = "f7c51b0d585eb63702f0d005081e53f44325df86";
    sha256 = "1gmnn72ablfxvv13s0rms5f39hc4y2z97aq44d7l9hblnfn6wq12";
  };

  buildInputs = [ libfprint glib dbus_glib polkit nss pam systemd ];
  nativeBuildInputs = [ automake libtool autoconf gtk_doc pkgconfig intltool ];

  configureScript = "./autogen.sh";

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/lib/systemd/system" ];

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/fprint/fprintd/";
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
