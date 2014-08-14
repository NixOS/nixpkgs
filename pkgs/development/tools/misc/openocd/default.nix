{ stdenv, fetchurl, libftdi, libusb1, pkgconfig }:

# TODO: Add "hidapi" as dependency to gain access to CMSIS-DAP debuggers.
# Support should be auto-detected, but if not, pass "--enable-cmsis-dap" to
# configure.

stdenv.mkDerivation rec {
  name = "openocd-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/openocd/openocd-${version}.tar.bz2";
    sha256 = "0byk7hnccgmhw0f84qlkfhps38gp2xp628bfrsc03vq08hr6q1sv";
  };

  buildInputs = [ libftdi libusb1 pkgconfig ];

  configureFlags = [
    "--enable-jtag_vpi"
    "--enable-usb_blaster_libftdi"
    "--enable-amtjtagaccel"
    "--enable-gw16012"
    "--enable-presto_libftdi"
    "--enable-openjtag_ftdi"
    "--enable-oocd_trace"
    "--enable-buspirate"
    "--enable-sysfsgpio"
    "--enable-remote-bitbang"
  ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d"
    ln -s "$out/share/openocd/contrib/99-openocd.rules" "$out/etc/udev/rules.d/99-openocd.rules"
  '';

  meta = with stdenv.lib; {
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
    maintainers = with maintainers; [ viric bjornfor ];
    platforms = platforms.linux;
  };
}
