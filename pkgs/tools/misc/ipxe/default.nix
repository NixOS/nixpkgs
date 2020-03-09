{ stdenv, lib, fetchFromGitHub, perl, cdrkit, syslinux, xz, openssl, gnu-efi, mtools
, embedScript ? null
, additionalTargets ? {}
}:

let
  targets = additionalTargets // lib.optionalAttrs stdenv.isx86_64 {
    "bin-x86_64-efi/ipxe.efi" = null;
    "bin-x86_64-efi/ipxe.efirom" = null;
    "bin-x86_64-efi/ipxe.usb" = "ipxe-efi.usb";
  } // {
    "bin/ipxe.dsk" = null;
    "bin/ipxe.usb" = null;
    "bin/ipxe.iso" = null;
    "bin/ipxe.lkrn" = null;
    "bin/undionly.kpxe" = null;
  };
in

stdenv.mkDerivation rec {
  pname = "ipxe";
  version = "1.20.1";

  nativeBuildInputs = [ perl cdrkit syslinux xz openssl gnu-efi mtools ];

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "ipxe";
    rev = "v${version}";
    sha256 = "0w7h7y97gj9nqvbmsg1zp6zj5mpbbpckqbbx7bpp6k3ahy5fk8zp";
  };

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "ISOLINUX_BIN_LIST=${syslinux}/share/syslinux/isolinux.bin"
      "LDLINUX_C32=${syslinux}/share/syslinux/ldlinux.c32"
    ] ++ lib.optional (embedScript != null) "EMBED=${embedScript}";


  enabledOptions = [
    "PING_CMD"
    "IMAGE_TRUST_CMD"
    "DOWNLOAD_PROTO_HTTP"
    "DOWNLOAD_PROTO_HTTPS"
  ];

  configurePhase = ''
    runHook preConfigure
    for opt in $enabledOptions; do echo "#define $opt" >> src/config/general.h; done
    sed -i '/cp \''${ISOLINUX_BIN}/s/$/ --no-preserve=mode/' src/util/geniso
    substituteInPlace src/Makefile.housekeeping --replace '/bin/echo' echo
    runHook postConfigure
  '';

  preBuild = "cd src";

  buildFlags = lib.attrNames targets;

  installPhase = ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (from: to:
      if to == null
      then "cp -v ${from} $out"
      else "cp -v ${from} $out/${to}") targets)}

    # Some PXE constellations especially with dnsmasq are looking for the file with .0 ending
    # let's provide it as a symlink to be compatible in this case.
    ln -s undionly.kpxe $out/undionly.kpxe.0
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib;
    { description = "Network boot firmware";
      homepage = https://ipxe.org/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ehmry ];
      platforms = [ "x86_64-linux" "i686-linux" ];
    };
}
