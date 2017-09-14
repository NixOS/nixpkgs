{stdenv, fetchurl, pkgconfig, glib, gperf, utillinux}:
let
  s = # Generated upstream information
  rec {
    baseName="eudev";
    version = "3.2.1";
    name="${baseName}-${version}";
    url="http://dev.gentoo.org/~blueness/eudev/eudev-${version}.tar.gz";
    sha256 = "06gyyl90n85x8i7lfhns514y1kg1ians13l467admyzy3kjxkqsp";
  };
  buildInputs = [
    glib pkgconfig gperf utillinux
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  patches = [
    (fetchurl {
       # for new gperf
       url = "https://github.com/gentoo/eudev/commit/5bab4d8de0dcbb8e2e7d4d5125b4aea1652a0d60.patch";
       sha256 = "097pjmgq243mz3vfxndwmm37prmacgq2f4r4gb47whfkbd6syqcw";
    })
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];
  makeFlags = [
    "hwdb_bin=/var/lib/udev/hwdb.bin"
    "udevrulesdir=/etc/udev/rules.d"
    ];

  preInstall = ''
    # Disable install-exec-hook target as it conflicts with our move-sbin setup-hook
    sed -i 's;$(MAKE) $(AM_MAKEFLAGS) install-exec-hook;$(MAKE) $(AM_MAKEFLAGS);g' src/udev/Makefile
  '';

  installFlags =
    [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/etc"
    "udevconfdir=$(out)/etc/udev"
    "udevhwdbbin=$(out)/var/lib/udev/hwdb.bin"
    "udevhwdbdir=$(out)/var/lib/udev/hwdb.d"
    "udevrulesdir=$(out)/var/lib/udev/rules.d"
    ];
  enableParallelBuilding = true;
  meta = {
    inherit (s) version;
    description = ''An udev fork by Gentoo'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = ''https://www.gentoo.org/proj/en/eudev/'';
    downloadPage = ''http://dev.gentoo.org/~blueness/eudev/'';
    updateWalker = true;
  };
}
