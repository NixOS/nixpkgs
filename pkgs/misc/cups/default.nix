{ stdenv, fetchurl, fetchpatch, pkgconfig, removeReferencesTo
, zlib, libjpeg, libpng, libtiff, pam, dbus, systemd, acl, gmp, darwin
, libusb ? null, gnutls ? null, avahi ? null, libpaper ? null
, coreutils
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
      name = "cups"; # weird name to avoid change (for now)
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/cups-systemd-socket.patch"
          + "?h=packages/cups&id=41fefa22ac518";
      sha256 = "1ddgdlg9s0l2ph6l8lx1m1lx6k50gyxqi3qiwr44ppq1rxs80ny5";
    })
    ./cups-clean-dirty.patch
  ];

  postPatch = ''
    substituteInPlace cups/testfile.c \
      --replace 'cupsFileFind("cat", "/bin' 'cupsFileFind("cat", "${coreutils}/bin'
  '';

  nativeBuildInputs = [ pkgconfig removeReferencesTo ];

  buildInputs = [ zlib libjpeg libpng libtiff libusb gnutls libpaper ]
    ++ optionals stdenv.isLinux [ avahi pam dbus systemd acl ]
    ++ optionals stdenv.isDarwin (with darwin; [
      configd apple_sdk.frameworks.ApplicationServices
    ]);

  propagatedBuildInputs = [ gmp ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-raw-printing"
    "--enable-threads"
  ] ++ optionals stdenv.isLinux [
    "--enable-dbus"
    "--enable-pam"
  ] ++ optional (libusb != null) "--enable-libusb"
    ++ optional (gnutls != null) "--enable-ssl"
    ++ optional (avahi != null) "--enable-avahi"
    ++ optional (libpaper != null) "--enable-libpaper"
    ++ optional stdenv.isDarwin "--disable-launchd";

  preConfigure = ''
    configureFlagsArray+=(
      # Put just lib/* and locale into $lib; this didn't work directly.
      # lib/cups is moved back to $out in postInstall.
      # Beware: some parts of cups probably don't fully respect these.
      "--prefix=$lib"
      "--datadir=$out/share"
      "--localedir=$lib/share/locale"

      "--with-systemd=$out/lib/systemd/system"

      ${optionalString stdenv.isDarwin ''
        "--with-bundledir=$out"
      ''}
    )
  '';

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
      libexec=${if stdenv.isDarwin then "libexec/cups" else "lib/cups"}
      moveToOutput $libexec "$out"

      # $lib contains references to $out/share/cups.
      # CUPS is working without them, so they are not vital.
      find "$lib" -type f -exec grep -q "$out" {} \; \
           -printf "removing references from %p\n" \
           -exec remove-references-to -t "$out" {} +

      # Delete obsolete stuff that conflicts with cups-filters.
      rm -rf $out/share/cups/banners $out/share/cups/data/testprint

      moveToOutput bin/cups-config "$dev"
      sed -e "/^cups_serverbin=/s|$lib|$out|" \
          -i "$dev/bin/cups-config"

      # Rename systemd files provided by CUPS
      for f in "$out"/lib/systemd/system/*; do
        substituteInPlace "$f" \
          --replace "$lib/$libexec" "$out/$libexec" \
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
