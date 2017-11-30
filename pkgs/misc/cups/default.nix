{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, libpng, libtiff, pam
, dbus, systemd, acl, gmp, darwin
, libusb ? null, gnutls ? null, avahi ? null, libpaper ? null
}:

### IMPORTANT: before updating cups, make sure the nixos/tests/printing.nix test
### works at least for your platform.

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "cups-${version}";
  version = "2.2.6";

  passthru = { inherit version; };

  src = fetchurl {
    url = "https://github.com/apple/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
    sha256 = "16qn41b84xz6khrr2pa2wdwlqxr29rrrkjfi618gbgdkq9w5ff20";
  };

  outputs = [ "out" "lib" "dev" "man" ];

  patches = [
    (fetchpatch {
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/cups-systemd-socket.patch?h=packages/cups";
      sha256 = "1ddgdlg9s0l2ph6l8lx1m1lx6k50gyxqi3qiwr44ppq1rxs80ny5";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib libjpeg libpng libtiff libusb gnutls libpaper ]
    ++ optionals stdenv.isLinux [ avahi pam dbus systemd acl ]
    ++ optionals stdenv.isDarwin (with darwin; [
      configd apple_sdk.frameworks.ApplicationServices
    ]);

  propagatedBuildInputs = [ gmp ];

  configureFlags = [
    # Put just lib/* and locale into $lib; this didn't work directly.
    # lib/cups is moved back to $out in postInstall.
    # Beware: some parts of cups probably don't fully respect these.
    "--prefix=$(lib)"
    "--datadir=$(out)/share"
    "--localedir=$(lib)/share/locale"

    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-rundir=/run"
    "--with-systemd=\${out}/lib/systemd/system"
    "--enable-raw-printing"
    "--enable-threads"
  ] ++ optionals stdenv.isLinux [
    "--enable-dbus"
    "--enable-pam"
  ] ++ optional (libusb != null) "--enable-libusb"
    ++ optional (gnutls != null) "--enable-ssl"
    ++ optional (avahi != null) "--enable-avahi"
    ++ optional (libpaper != null) "--enable-libpaper"
    ++ optionals stdenv.isDarwin [
    "--with-bundledir=$out"
    "--disable-launchd"
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
      "XINETD=$(out)/etc/xinetd.d"
      "SERVERROOT=$(out)/etc/cups"
      # Idem for /usr.
      "MENUDIR=$(out)/share/applications"
      "ICONDIR=$(out)/share/icons"
      # Work around a Makefile bug.
      "CUPS_PRIMARY_SYSTEM_GROUP=root"
    ];

  enableParallelBuilding = true;

  postInstall = ''
      moveToOutput lib/cups "$out"

      # Delete obsolete stuff that conflicts with cups-filters.
      rm -rf $out/share/cups/banners $out/share/cups/data/testprint

      # Some outputs in cups-config were unexpanded and some even wrong.
      moveToOutput bin/cups-config "$dev"
      sed -e "/^cups_serverbin=/s|\$(lib)|$out|" \
          -e "s|\$(out)|$out|" \
          -e "s|\$(lib)|$lib|" \
          -i "$dev/bin/cups-config"

      # Rename systemd files provided by CUPS
      for f in "$out"/lib/systemd/system/*; do
        substituteInPlace "$f" \
          --replace "org.cups.cupsd" "cups" \
          --replace "org.cups." ""

        if [[ "$f" =~ .*cupsd\..* ]]; then
          mv "$f" "''${f/org\.cups\.cupsd/cups}"
        else
          mv "$f" "''${f/org\.cups\./}"
        fi
      done
    '' + optionalString stdenv.isLinux ''
      # Use xdg-open when on Linux
      substituteInPlace "$out"/share/applications/cups.desktop \
        --replace "Exec=htmlview" "Exec=xdg-open"
    '';

  meta = {
    homepage = https://cups.org/;
    description = "A standards-based printing system for UNIX";
    license = licenses.gpl2; # actually LGPL for the library and GPL for the rest
    maintainers = with maintainers; [ jgeerds ];
    platforms = platforms.unix;
  };
}
