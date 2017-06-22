{ stdenv, fetchgit, perl, cdrkit, syslinux, xz, openssl }:

let
  date = "20170523";
  rev = "356f6c1b64d7a97746d1816cef8ca22bdd8d0b5d";
in

stdenv.mkDerivation {
  name = "ipxe-${date}-${builtins.substring 0 7 rev}";

  buildInputs = [ perl cdrkit syslinux xz openssl ];

  src = fetchgit {
    url = git://git.ipxe.org/ipxe.git;
    sha256 = "15n400vm3id5r8y3k6lrp9ab2911a9vh9856f5gvphkazfnmns09";
    inherit rev;
  };

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "ISOLINUX_BIN_LIST=${syslinux}/share/syslinux/isolinux.bin"
    ];


  enabledOptions = [ "DOWNLOAD_PROTO_HTTPS" ];

  configurePhase = ''
    runHook preConfigure
    for opt in $enabledOptions; do echo "#define $opt" >> src/config/general.h; done
    runHook postConfigure
  '';

  preBuild = "cd src";

  installPhase = ''
    mkdir -p $out
    cp bin/ipxe.dsk bin/ipxe.usb bin/ipxe.iso bin/ipxe.lkrn bin/undionly.kpxe $out
  '';

  meta = with stdenv.lib;
    { description = "Network boot firmware";
      homepage = http://ipxe.org/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ehmry fpletz ];
      platforms = platforms.all;
    };
}
