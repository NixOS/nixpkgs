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
, enableSystemd ? stdenv.isLinux
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

with lib;
stdenv.mkDerivation rec {
  pname = "cups";

  # After 2.2.6, CUPS requires headers only available in macOS 10.12+
  version = if stdenv.isDarwin then "2.2.6" else "2.4.0";

  src = fetchurl (if stdenv.isDarwin then {
    url = "https://github.com/apple/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
    sha256 = "16qn41b84xz6khrr2pa2wdwlqxr29rrrkjfi618gbgdkq9w5ff20";
  } else {
    url = "https://github.com/OpenPrinting/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
    sha256 = "1pm6lf08z8vgs62g5b5rjw32qy3vr0q3sgidpg2lfs6a530wxgls";
  });

  outputs = [ "out" "lib" "dev" "man" ];

  patches = lib.optional (version == "2.2.6") ./0001-TargetConditionals.patch;

  postPatch = ''
    substituteInPlace cups/testfile.c \
      --replace 'cupsFileFind("cat", "/bin' 'cupsFileFind("cat", "${coreutils}/bin'
  '';

  nativeBuildInputs = [ pkg-config removeReferencesTo ];

  buildInputs = [ zlib libjpeg libpng libtiff libusb1 gnutls libpaper ]
    ++ optionals stdenv.isLinux [ avahi pam dbus acl ]
    ++ optional enableSystemd systemd
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
    "--with-dbusdir=${placeholder "out"}/share/dbus-1"
  ] ++ optional (libusb1 != null) "--enable-libusb"
    ++ optional (gnutls != null) "--enable-ssl"
    ++ optional (avahi != null) "--enable-avahi"
    ++ optional (libpaper != null) "--enable-libpaper"
    ++ optional stdenv.isDarwin "--disable-launchd";

  # AR has to be an absolute path
  preConfigure = ''
    export AR="${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
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
    '' + optionalString stdenv.isLinux ''
      # Use xdg-open when on Linux
      substituteInPlace "$out"/share/applications/cups.desktop \
        --replace "Exec=htmlview" "Exec=xdg-open"
    '';

  passthru.tests.nixos = nixosTests.printing;

  meta = {
    homepage = "https://openprinting.github.io/cups/";
    description = "A standards-based printing system for UNIX";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };
}
