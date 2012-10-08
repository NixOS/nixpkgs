{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, libpng, libtiff, pam, openssl
, dbus, libusb, acl }:

let
  version = "1.5.2";
in
stdenv.mkDerivation {
  name = "cups-${version}";

  passthru = { inherit version; };

  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "1yw7l5rq93zg91akqf68b871frrs4q0krc9cx43ly7v3ih8all5i";
  };

  buildInputs = [ pkgconfig zlib libjpeg libpng libtiff libusb ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pam dbus acl ] ;

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
    homepage = "http://www.cups.org/";
    description = "A standards-based printing system for UNIX";
    license = stdenv.lib.licenses.gpl2; # actually LGPL for the library and GPL for the rest
    maintainers = [ stdenv.lib.maintainers.urkud stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
