{ stdenv, fetchgit, perl, cdrkit, syslinux }:

let
  date = "20141124";
  rev = "5cbdc41778622c07429e00f5aee383b575532bf0";
in

stdenv.mkDerivation {
  name = "ipxe-${date}-${builtins.substring 0 7 rev}";

  buildInputs = [ perl cdrkit syslinux ];

  src = fetchgit {
    url = git://git.ipxe.org/ipxe.git;
    sha256 = "0wiy3kag6x8a2a71pc9za9izmac8gdz90vaqp2mwgih6p2lz01zq";
    inherit rev;
  };

  preConfigure = "cd src";

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "ISOLINUX_BIN_LIST=${syslinux}/share/syslinux/isolinux.bin"
    ];

  installPhase =
    ''
      mkdir $out
      cp bin/ipxe.dsk bin/ipxe.usb bin/ipxe.iso bin/ipxe.lkrn bin/undionly.kpxe $out
    '';

  meta = with stdenv.lib;
    { description = "Network boot firmware";
      homepage = http://ipxe.org/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.all;
    };
}
