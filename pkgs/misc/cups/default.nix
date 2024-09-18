{ lib, stdenv
, fetchurl
, pkg-config
, removeReferencesTo
, zlib
, libjpeg
, libpng
, libtiff
, pam
, dbus
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, acl
, gmp
, darwin
, libusb1 ? null
, gnutls ? null
, avahi ? null
, libpaper ? null
, coreutils
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cups";
  version = "2.4.10";

  src = fetchurl {
    url = "https://github.com/OpenPrinting/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
    sha256 = "sha256-11dXwrwPeiiwLuTVLKnksaoboq/+FrmFhU9TNpQOWtc=";
  };

  outputs = [ "out" "lib" "dev" "man" ];

  postPatch = ''
    substituteInPlace cups/testfile.c \
      --replace 'cupsFileFind("cat", "/bin' 'cupsFileFind("cat", "${coreutils}/bin'

      # The cups.socket unit shouldn't be part of cups.service: stopping the
      # service would stop the socket and break subsequent socket activations.
      # See https://github.com/apple/cups/issues/6005
      sed -i '/PartOf=cups.service/d' scheduler/cups.socket.in
  '' + lib.optionalString (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "12") ''
    substituteInPlace backend/usb-darwin.c \
      --replace "kIOMainPortDefault" "kIOMasterPortDefault"
  '';

  nativeBuildInputs = [ pkg-config removeReferencesTo ];

  buildInputs = [ zlib libjpeg libpng libtiff libusb1 gnutls libpaper ]
    ++ lib.optionals stdenv.isLinux [ avahi pam dbus acl ]
    ++ lib.optional enableSystemd systemd
    ++ lib.optionals stdenv.isDarwin (with darwin; [
      configd apple_sdk.frameworks.ApplicationServices
    ]);

  propagatedBuildInputs = [ gmp ];

  configurePlatforms = lib.optionals stdenv.isLinux [ "build" "host" ];
  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-raw-printing"
    "--enable-threads"
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-dbus"
    "--enable-pam"
    "--with-dbusdir=${placeholder "out"}/share/dbus-1"
  ] ++ lib.optional (libusb1 != null) "--enable-libusb"
    ++ lib.optional (gnutls != null) "--enable-ssl"
    ++ lib.optional (avahi != null) "--enable-avahi"
    ++ lib.optional (libpaper != null) "--enable-libpaper";

  # AR has to be an absolute path
  preConfigure = ''
    export AR="${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
    configureFlagsArray+=(
      # Put just lib/* and locale into $lib; this didn't work directly.
      # lib/cups is moved back to $out in postInstall.
      # Beware: some parts of cups probably don't fully respect these.
      "--prefix=$lib"
      "--datadir=$out/share"
      "--localedir=$lib/share/locale"

      "--with-systemd=$out/lib/systemd/system"

      ${lib.optionalString stdenv.isDarwin ''
        "--with-bundledir=$out"
      ''}
    )
  '';

  installFlags =
    [ # Don't try to write in /var at build time.
      "CACHEDIR=$(TMPDIR)/dummy"
      "LAUNCHD_DIR=$(TMPDIR)/dummy"
      "LOGDIR=$(TMPDIR)/dummy"
      "REQUESTS=$(TMPDIR)/dummy"
      "STATEDIR=$(TMPDIR)/dummy"
      # Idem for /etc.
      "PAMDIR=$(out)/etc/pam.d"
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

      for f in "$out"/lib/systemd/system/*; do
        substituteInPlace "$f" --replace "$lib/$libexec" "$out/$libexec"
      done
    '' + lib.optionalString stdenv.isLinux ''
      # Use xdg-open when on Linux
      substituteInPlace "$out"/share/applications/cups.desktop \
        --replace "Exec=htmlview" "Exec=xdg-open"
    '';

  passthru.tests = {
    inherit (nixosTests)
      printing-service
      printing-socket
    ;
  };

  meta = with lib; {
    homepage = "https://openprinting.github.io/cups/";
    description = "Standards-based printing system for UNIX";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };
}
