{ stdenv, fetchgit, perl, cdrkit, syslinux, lzma
, brand ? "vanilla", localConfigDir ? null }:

let
  date = "20160420";
  rev = "55e409b14fdfc6bcd51cdcdaf1ee20ad5258215d";
in

stdenv.mkDerivation {
  name = "ipxe-${brand}-${date}-${builtins.substring 0 7 rev}";

  buildInputs = [ perl cdrkit syslinux lzma.dev ];

  src = fetchgit {
    url = git://git.ipxe.org/ipxe.git;
    sha256 = "02shcp2wlbkfw6gnws52bv88wsw2wl9rlrks4d9vsxg4bwpik5fv";
    inherit rev;
  };

  prePatch = stdenv.lib.optionalString (localConfigDir != null) ''
    cp ${localConfigDir}/* src/config/local
  '';

  preConfigure = "cd src";

  enableParallelBuilding = true;

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
