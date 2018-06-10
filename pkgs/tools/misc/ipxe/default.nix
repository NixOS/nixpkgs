{ stdenv, lib, fetchgit, perl, cdrkit, syslinux, xz, openssl
, embedScript ? null
}:

let
  date = "20180220";
  rev = "47849be3a900c546cf92066849be0806f4e611d9";
in

stdenv.mkDerivation {
  name = "ipxe-${date}-${builtins.substring 0 7 rev}";

  buildInputs = [ perl cdrkit syslinux xz openssl ];

  src = fetchgit {
    url = git://git.ipxe.org/ipxe.git;
    sha256 = "1f4pi1dp2zqnrbfnggnzycfvrxv0bqgw73dxbyy3hfy4mhdj6z45";
    inherit rev;
  };

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "ISOLINUX_BIN_LIST=${syslinux}/share/syslinux/isolinux.bin"
      "LDLINUX_C32=${syslinux}/share/syslinux/ldlinux.c32"
    ] ++ lib.optional (embedScript != null) "EMBED=${embedScript}";


  enabledOptions = [ "DOWNLOAD_PROTO_HTTPS" ];

  configurePhase = ''
    runHook preConfigure
    for opt in $enabledOptions; do echo "#define $opt" >> src/config/general.h; done
    sed -i '/cp \''${ISOLINUX_BIN}/s/$/ --no-preserve=mode/' src/util/geniso
    runHook postConfigure
  '';

  preBuild = "cd src";

  installPhase = ''
    mkdir -p $out
    cp bin/ipxe.dsk bin/ipxe.usb bin/ipxe.iso bin/ipxe.lkrn bin/undionly.kpxe $out

    # Some PXE constellations especially with dnsmasq are looking for the file with .0 ending
    # let's provide it as a symlink to be compatible in this case.
    ln -s undionly.kpxe $out/undionly.kpxe.0
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib;
    { description = "Network boot firmware";
      homepage = http://ipxe.org/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.all;
    };
}
