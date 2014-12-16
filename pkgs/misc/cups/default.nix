{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, libpng, libtiff, pam, openssl
, dbus, libusb, acl }:

let version = "1.7.5"; in

stdenv.mkDerivation {
  name = "cups-${version}";

  passthru = { inherit version; };

  src = fetchurl {
    url = "https://www.cups.org/software/${version}/cups-${version}-source.tar.bz2";
    sha256 = "00mx4rpiqw9cwx46bd3hd5lcgmcxy63zfnmkr02smanv8xl4rjqq";
  };

  buildInputs = [ pkgconfig zlib libjpeg libpng libtiff libusb ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pam dbus.libs acl ] ;

  propagatedBuildInputs = [ openssl ];

  configureFlags = "--localstatedir=/var --sysconfdir=/etc --enable-dbus"; # --with-dbusdir

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
      "SERVERROOT=$(out)/etc/cups"
      # Idem for /usr.
      "MENUDIR=$(out)/share/applications"
      "ICONDIR=$(out)/share/icons"
      # Work around a Makefile bug.
      "CUPS_PRIMARY_SYSTEM_GROUP=root"
    ];

  postInstall =
    ''
      # Delete obsolete stuff that conflicts with cups-filters.
      rm -rf $out/share/cups/banners $out/share/cups/data/testprint
    '';

  meta = {
    homepage = "http://www.cups.org/";
    description = "A standards-based printing system for UNIX";
    license = stdenv.lib.licenses.gpl2; # actually LGPL for the library and GPL for the rest
    maintainers = [ stdenv.lib.maintainers.urkud stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
