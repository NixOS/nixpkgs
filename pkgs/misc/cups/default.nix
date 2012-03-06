{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, libpng, libtiff, pam, openssl
, dbus, libusb, acl }:

let
  version = "1.5.0";
in
stdenv.mkDerivation {
  name = "cups-${version}";

  passthru = { inherit version; };

  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "0czc0bmrm31jy03inm6w2mbr5s9q9xk6s1x5x4kddx2qlml9pyf6";
  };

  # The following code looks strange, but it had to be arranged like
  # this in order to avoid major rebuilds while testing portability to
  # non-Linux platforms. This should be cleaned once the expression is
  # stable.
  buildInputs = [ pkgconfig zlib libjpeg libpng libtiff ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pam dbus ]
    ++ [ libusb ]
    ++ stdenv.lib.optionals stdenv.isLinux [ acl ] ;

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
    license = stdenv.lib.licenses.gpl2; # actually LGPL for the library and GPL for the rest
    maintainers = [ stdenv.lib.maintainers.urkud stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
