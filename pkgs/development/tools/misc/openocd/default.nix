{ stdenv
, lib
, fetchgit
, autoreconfHook
, pkg-config
, hidapi
, libftdi1
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "openocd";
  version = "unstable-2020-11-11";

  src = fetchgit {
    url = "https://git.code.sf.net/p/openocd/code";
    rev = "06c7a53f1fff20bcc4be9e63f83ae98664777f34";
    sha256 = "0g0w7g94r88ylfpwswnhh8czlf5iqvd991ssn4gfcfd725lpdb01";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ hidapi libftdi1 libusb1 ];

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
    "-Wno-error=cpp"
    "-Wno-error=strict-prototypes" # fixes build failure with hidapi 0.10.0
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
    homepage = "https://openocd.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
