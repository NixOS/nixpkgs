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
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "cups";
  version = "2.4.8";

  src = fetchurl {
    url = "https://github.com/OpenPrinting/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
    sha256 = "sha256-dcMmtLpzl178yaJQeMSwTNtO4zPKqtDQgj29UixkeaA=";
  };

  outputs = [ "out" "lib" "dev" "man" ];

  patches = [
    (fetchpatch {
      name = "CVE-2024-35235.patch";
      url = "https://github.com/OpenPrinting/cups/commit/b273a1f29bda87317c551614cf9ab6125f56e317.patch";
      hash = "sha256-nzWKEMOEBKZMjqVPl2mcATtXZSrh++yhv9VMvbA+49E=";
    })
    # the following three patches fix a regression introduced by the patch above
    (fetchpatch {
      name = "CVE-2024-35235-fixup-domainsocket-1.patch";
      url = "https://github.com/OpenPrinting/cups/commit/6131f6a73c188f3db0ec94ae488991ce80cfd7ea.patch";
      hash = "sha256-uftOI0zkwPXsW8CY8BoOkx4BysjDUc66LuzyZDjUHCI=";
    })
    (fetchpatch {
      name = "CVE-2024-35235-fixup-domainsocket-2.patch";
      url = "https://github.com/OpenPrinting/cups/commit/4417cd366f7baf64f4ada3efbb3ec13cd773a0f4.patch";
      hash = "sha256-ighA4Vmf43iiwkNl71//Ml8ynh8nF/bcNOKELeJFPKo=";
    })
    (fetchpatch {
      name = "CVE-2024-35235-fixup-domainsocket-3.patch";
      url = "https://github.com/OpenPrinting/cups/commit/145b946a86062aafab76c656ee9c1112bfd4f804.patch";
      includes = [ "scheduler/conf.c" ];
      hash = "sha256-2jQFHUFav8XDfqA/PVKNvbUnZI34na8Wbuu4XRy3uqc=";
    })
    (fetchpatch {
      name = "CVE-2024-47175_0.patch";
      url = "https://github.com/OpenPrinting/cups/commit/9939a70b750edd9d05270060cc5cf62ca98cfbe5.patch";
      hash = "sha256-Nt6/JwoaHkzFxCl1BuXOQRfki8Oquk2rIwvw7qekTQI=";
    })
    (fetchpatch {
      name = "CVE-2024-47175_1.patch";
      url = "https://github.com/OpenPrinting/cups/commit/04bb2af4521b56c1699a2c2431c56c05a7102e69.patch";
      hash = "sha256-ZyvVAv96pK6ldSQf5IOiIXk8xYeNJOWNHX0S5pyn6pw=";
    })
    (fetchpatch {
      name = "CVE-2024-47175_2.patch";
      url = "https://github.com/OpenPrinting/cups/commit/e0630cd18f76340d302000f2bf6516e99602b844.patch";
      hash = "sha256-uDUOIwkRGZo+XXheDt+HGsXujtEJ3b4o5yNWdnz5uIY=";
    })
    (fetchpatch {
      name = "CVE-2024-47175_3.patch";
      url = "https://github.com/OpenPrinting/cups/commit/1e6ca5913eceee906038bc04cc7ccfbe2923bdfd.patch";
      hash = "sha256-SiYUsa+DUNPua0/r/rvzzRAYra2AP49ImbyWG5RnCI0=";
    })
    (fetchpatch {
      name = "CVE-2024-47175_4.patch";
      url = "https://github.com/OpenPrinting/cups/commit/2abe1ba8a66864aa82cd9836b37e57103b8e1a3b.patch";
      hash = "sha256-oeZ3nNmPMkusxZhmmKOCcD/AD+QzkVE8acNXapGK/Ew=";
    })
  ];

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
    description = "A standards-based printing system for UNIX";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.unix;
  };
}
