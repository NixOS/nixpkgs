{stdenv, fetchurl, libftdi}:

let
  # The "GuruPlug installer" from Marvell.  See
  # <http://www.plugcomputer.org/index.php/us/resources/downloads?func=select&id=16>,
  # linked from <http://www.globalscaletechnologies.com/t-downloads.aspx>.
  guruplug_installer = fetchurl {
    url = "http://www.plugcomputer.org/index.php/us/resources/downloads?func=download&id=65&chk=d6878f4bf86070f7b4f7bc93317fcb0f&no_html=1";
    sha256 = "1nps9li9k1kxb31f9x6d114hh0a3bx886abvgh8vg004ni996hlv";
    name = "guruplug-installer.tar.gz";
  };
in
stdenv.mkDerivation {
  name = "openocd-0.4.0";

  src = fetchurl {
    url = "http://download.berlios.de/openocd/openocd-0.4.0.tar.bz2";
    sha256 = "1c9j8s3mqgw5spv6nd4lqfkd1l9jmjipi0ya054vnjfsy2617kzv";
  };

  configureFlags = [ "--enable-ft2232_libftdi" "--disable-werror" ];

  buildInputs = [ libftdi ];

  # Copy the GuruPlug stuff.
  # XXX: Unfortunately, these files were written for OpenOCD 0.2.0 and don't
  # work with 0.4.0.
  # postInstall =
  #   '' tar xf "${guruplug_installer}"
  #      for dir in interface target board
  #      do
  #        cp -v "guruplug-installer/openocd/$dir/"* \
  #              "$out/share/openocd/scripts/$dir/"
  #      done
  #   '';

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
