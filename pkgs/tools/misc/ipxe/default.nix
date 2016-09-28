{ stdenv, fetchgit, perl, cdrkit, syslinux, xz, openssl }:

let
  date = "20160831";
  rev = "827dd1bfee67daa683935ce65316f7e0f057fe1c";
in

stdenv.mkDerivation {
  name = "ipxe-${date}-${builtins.substring 0 7 rev}";

  buildInputs = [ perl cdrkit syslinux xz openssl ];

  src = fetchgit {
    url = git://git.ipxe.org/ipxe.git;
    sha256 = "11w8b0vln3skfn8r1cvzngslz12njdkwmnacyq3qffb96k2dn2ww";
    inherit rev;
  };

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "ISOLINUX_BIN_LIST=${syslinux}/share/syslinux/isolinux.bin"
    ];


  configurePhase = ''
    echo "#define  DOWNLOAD_PROTO_HTTPS" >> src/config/general.h
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
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.all;
    };
}
