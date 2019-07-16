{ stdenv, lib, fetchurl, libftdi1, libusb1, pkgconfig, hidapi }:

stdenv.mkDerivation rec {
  name = "openocd-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/openocd/openocd-${version}.tar.bz2";
    sha256 = "1bhn2c85rdz4gf23358kg050xlzh7yxbbwmqp24c0akmh3bff4kk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libftdi1 libusb1 hidapi ];

  configureFlags = [
    "--enable-jtag_vpi"
    "--enable-usb_blaster_libftdi"
    (lib.enableFeature (! stdenv.isDarwin) "amtjtagaccel")
    (lib.enableFeature (! stdenv.isDarwin) "gw16012")
    "--enable-presto_libftdi"
    "--enable-openjtag_ftdi"
    (lib.enableFeature (! stdenv.isDarwin) "oocd_trace")
    "--enable-buspirate"
    (lib.enableFeature stdenv.isLinux "sysfsgpio")
    "--enable-remote-bitbang"
  ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    "-Wno-implicit-fallthrough"
    "-Wno-format-truncation"
    "-Wno-format-overflow"
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';

  meta = with lib; {
    description = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing";
    longDescription = ''
      OpenOCD provides on-chip programming and debugging support with a layered
      architecture of JTAG interface and TAP support, debug target support
      (e.g. ARM, MIPS), and flash chip drivers (e.g. CFI, NAND, etc.).  Several
      network interfaces are available for interactiving with OpenOCD: HTTP,
      telnet, TCL, and GDB.  The GDB server enables OpenOCD to function as a
      "remote target" for source-level debugging of embedded systems using the
      GNU GDB program.
    '';
    homepage = http://openocd.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
