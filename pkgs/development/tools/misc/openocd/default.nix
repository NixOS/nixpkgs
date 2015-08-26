{ stdenv, fetchurl, libftdi, libusb1, pkgconfig, hidapi }:

stdenv.mkDerivation rec {
  name = "openocd-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/openocd/openocd-${version}.tar.bz2";
    sha256 = "0hzlnm19c4b35vsxs6ik94xbigv3ykdgr8gzrdir6sqmkan44w43";
  };

  buildInputs = [ libftdi libusb1 pkgconfig hidapi ];

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
