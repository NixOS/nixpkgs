{stdenv, fetchurl, libftdi}:

stdenv.mkDerivation rec {
  name = "openocd-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/openocd/openocd/${version}/openocd-${version}.tar.bz2";
    sha256 = "0argjhff9x4ilgycics61kfgkvb6kkkhhhmj3fxcyydd8mscri7l";
  };

  configureFlags = [ "--enable-ft2232_libftdi"
                     "--enable-jlink"
                     "--enable-rlink"
                     "--enable-ulink"
                     "--enable-stlink" ];

  buildInputs = [ libftdi ];

  meta = {
    homepage = http://openocd.berlios.de;
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
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
