{ stdenv, fetchurl, pkgconfig, zlib, pam, openssl
, dbus, libusb, acl }:

let version = "2.0.0"; in

stdenv.mkDerivation rec {
  name = "cups-${version}";

  src = fetchurl {
    url = "https://www.cups.org/software/${version}/${name}-source.tar.bz2";
    sha256 = "1qjv1w8m3f9lbrnd9wx8gman4sjbgb75svfypd4jkn649b5vpzc3";
  };

  buildInputs = [ pkgconfig zlib libusb ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pam dbus.libs acl ] ;

  propagatedBuildInputs = [ openssl ];

  patches = [ ./use-initgroups.patch ];

  configureFlags = [ "--localstatedir=/var" "--enable-dbus"
                     # Workaround for installing systemd path
                     "--with-systemd=$out/lib/systemd/system"
                   ];

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
    platforms = stdenv.lib.platforms.linux;
  };
}
