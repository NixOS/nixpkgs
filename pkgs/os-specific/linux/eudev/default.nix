{stdenv, fetchurl, pkgconfig, glib, gperf, utillinux, kmod}:
let
  s = # Generated upstream information
  rec {
    baseName="eudev";
    version = "3.2.4";
    name="${baseName}-${version}";
    url="http://dev.gentoo.org/~blueness/eudev/eudev-${version}.tar.gz";
    sha256 = "1vbg2k5mngyxdcdw4jkkzxbwdgrcr643hkby1whz7x91kg4g9p6x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glib gperf utillinux kmod
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  patches = [
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
