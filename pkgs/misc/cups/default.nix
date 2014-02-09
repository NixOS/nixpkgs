{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, libpng, libtiff, pam, openssl
, dbus, libusb, acl, versionedDerivation
, ghostscript
, version ? "1.5.4"
}:

versionedDerivation "cups" version {

  "1.5.4" = {

    name = "cups-${version}";

    src = fetchurl {
      url = "http://www.cups.org/software/1.5.4/cups-1.5.4-source.tar.bz2";
      md5 = "de3006e5cf1ee78a9c6145ce62c4e982"; # hash changed (2013-10)
    };

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
   };
  "1.6.4" = {

    name = "cups-${version}";

    src = fetchurl {
      url = http://www.cups.org/software/1.6.4/cups-1.6.4-source.tar.bz2;
      sha256 = "0wvy3cxyk9a9bw5angcqr480fpa597l109yiai0za1id7gjc645r";
    };

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

  };

  "1.7.x" = {
    # new --with-rundir option, use it?

    name = "cups-${version}";

    src = fetchurl {
      url = http://www.cups.org/software/1.7.0/cups-1.7.0-source.tar.bz2;
      md5 = "5ab496a2ce27017fcdb3d7ec4818a75a";
    };

    configureFlags = "--localstatedir=/var --enable-dbus"; # --with-dbusdir

    # preBuild = ''
    # sed -i 's@/usr/bin/gs@gs@' config.h.in config.h */config.h
    # '';

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

  };
} {
  # explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".
  LDFLAGS = "-lgcc_s";

  enableParallelBuilding = true;

  passthru = { inherit version; };

  buildInputs = [ pkgconfig zlib libjpeg libpng libtiff libusb ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pam dbus.libs acl ] ;

  propagatedBuildInputs = [ openssl ];


  meta = {
    homepage = "http://www.cups.org/";
    description = "A standards-based printing system for UNIX";
    license = stdenv.lib.licenses.gpl2; # actually LGPL for the library and GPL for the rest
    maintainers = [ stdenv.lib.maintainers.urkud stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
