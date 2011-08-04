{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, libpng, libtiff, pam, openssl
, dbus, libusb, acl }:

let version = "1.4.7"; in

stdenv.mkDerivation {
  name = "cups-${version}";

  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "1xlnkdqldq81pdqgisqbyh92k249bzz35m1f5bp4la06p00ksvjf";
  };

  buildInputs = [ pkgconfig zlib libjpeg libpng libtiff pam dbus libusb acl ];

  propagatedBuildInputs = [ openssl ];

  configureFlags = "--localstatedir=/var --enable-dbus"; # --with-dbusdir

  installFlags =
    [ # Don't try to write in /var at build time.
      "CACHEDIR=$(TMPDIR)/dummy"
      "LOGDIR=$(TMPDIR)/dummy"
      "REQUESTS=$(TMPDIR)/dummy"
      "STATEDIR=$(TMPDIR)/dummy"
      # Idem for /etc.
      "PAMDIR=$(out)/etc/pam.d"
      "DBUSDIR=$(out)/etc/dbus-1"
      "INITDIR=$(out)/etc/rc.d"
      "XINETD=$(out)/etc/xinetd.d"
      # Idem for /usr.
      "MENUDIR=$(out)/share/applications"
      "ICONDIR=$(out)/share/icons"
      # Work around a Makefile bug.
      "CUPS_PRIMARY_SYSTEM_GROUP=root"
    ];

  meta = {
    homepage = http://www.cups.org/;
    description = "A standards-based printing system for UNIX";
    license = "GPLv2"; # actually LGPL for the library and GPL for the rest
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
