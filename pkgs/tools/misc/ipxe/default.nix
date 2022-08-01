{ stdenv, lib, fetchFromGitHub, unstableGitUpdater, buildPackages
, gnu-efi, mtools, openssl, perl, xorriso, xz
, syslinux ? null
, embedScript ? null
, additionalTargets ? {}
}:

let
  targets = additionalTargets // lib.optionalAttrs stdenv.isx86_64 {
    "bin-x86_64-efi/ipxe.efi" = null;
    "bin-x86_64-efi/ipxe.efirom" = null;
    "bin-x86_64-efi/ipxe.usb" = "ipxe-efi.usb";
  } // lib.optionalAttrs stdenv.hostPlatform.isx86 {
    "bin/ipxe.dsk" = null;
    "bin/ipxe.usb" = null;
    "bin/ipxe.iso" = null;
    "bin/ipxe.lkrn" = null;
    "bin/undionly.kpxe" = null;
  } // lib.optionalAttrs stdenv.isAarch32 {
    "bin-arm32-efi/ipxe.efi" = null;
    "bin-arm32-efi/ipxe.efirom" = null;
    "bin-arm32-efi/ipxe.usb" = "ipxe-efi.usb";
  } // lib.optionalAttrs stdenv.isAarch64 {
    "bin-arm64-efi/ipxe.efi" = null;
    "bin-arm64-efi/ipxe.efirom" = null;
    "bin-arm64-efi/ipxe.usb" = "ipxe-efi.usb";
  };
in

stdenv.mkDerivation rec {
  pname = "ipxe";
  version = "unstable-2022-04-06";

  nativeBuildInputs = [ gnu-efi mtools openssl perl xorriso xz ] ++ lib.optional stdenv.hostPlatform.isx86 syslinux;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "ipxe";
    rev = "70995397e5bdfd3431e12971aa40630c7014785f";
    sha256 = "SrTNEYk13JXAcJuogm9fZ7CrzJIDRc0aziGdjRNv96I=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace src/util/genfsimg --replace "	syslinux " "	true "
  ''; # calling syslinux on a FAT image isn't going to work

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "CROSS=${stdenv.cc.targetPrefix}"
    ] ++ lib.optional (embedScript != null) "EMBED=${embedScript}";


  enabledOptions = [
    "PING_CMD"
    "IMAGE_TRUST_CMD"
    "DOWNLOAD_PROTO_HTTP"
    "DOWNLOAD_PROTO_HTTPS"
  ];

  configurePhase = ''
    runHook preConfigure
    for opt in ${lib.escapeShellArgs enabledOptions}; do echo "#define $opt" >> src/config/general.h; done
    substituteInPlace src/Makefile.housekeeping --replace '/bin/echo' echo
  '' + lib.optionalString stdenv.hostPlatform.isx86 ''
    substituteInPlace src/util/genfsimg --replace /usr/lib/syslinux ${syslinux}/share/syslinux
  '' + ''
    runHook postConfigure
  '';

  preBuild = "cd src";

  buildFlags = lib.attrNames targets;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (from: to:
      if to == null
      then "cp -v ${from} $out"
      else "cp -v ${from} $out/${to}") targets)}

    # Some PXE constellations especially with dnsmasq are looking for the file with .0 ending
    # let's provide it as a symlink to be compatible in this case.
    ln -s undionly.kpxe $out/undionly.kpxe.0

    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib;
    { description = "Network boot firmware";
      homepage = "https://ipxe.org/";
      license = licenses.gpl2Only;
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.linux;
    };
}
