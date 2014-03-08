{ stdenv, fetchurl, libftdi, libusb1 }:

stdenv.mkDerivation rec {
  name = "openocd-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/openocd/openocd-${version}.tar.bz2";
    sha256 = "0qwfyd821sy5p0agz0ybgn5nd7vplipw4mhm485ldj1hcmw7n8sj";
  };

  configureFlags = [ "--enable-ft2232_libftdi"
                     "--enable-jlink"
                     "--enable-rlink"
                     "--enable-ulink"
                     "--enable-stlink" ];

  buildInputs = [ libftdi libusb1 ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d"
    ln -s "$out/share/openocd/contrib/openocd.udev" "$out/etc/udev/rules.d/99-openocd.rules"
  '';

  meta = {
    homepage = http://openocd.sourceforge.net/;
    description = "OpenOCD, an on-chip debugger";

    longDescription =
      '' OpenOCD provides on-chip programming and debugging support with a
         layered architecture of JTAG interface and TAP support, debug target
         support (e.g. ARM, MIPS), and flash chip drivers (e.g. CFI, NAND,
         etc.).  Several network interfaces are available for interactiving
         with OpenOCD: HTTP, telnet, TCL, and GDB.  The GDB server enables
         OpenOCD to function as a "remote target" for source-level debugging
         of embedded systems using the GNU GDB program.
      '';

    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ viric bjornfor ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
