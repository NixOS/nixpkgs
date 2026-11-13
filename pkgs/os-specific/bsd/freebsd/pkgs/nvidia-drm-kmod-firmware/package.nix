{
  lib,
  mkDerivation,
  sys,
  xargs-j,
  kldxref,
  nvidia-drm-kmod,
}:
mkDerivation {
  path = "...";
  pname = "nvidia-drm-kmod-firmware";
  inherit (nvidia-drm-kmod) version src;

  extraNativeBuildInputs = [
    xargs-j
    kldxref
  ];

  makeFlags = [
    "SYSDIR=${sys.src}/sys"
    "KMODDIR=${builtins.placeholder "out"}/kernel"
    "NO_XREF=1"
  ];

  hardeningDisable = [
    "pic" # generates relocations the linker can't handle
  ];

  preConfigure = ''
    cd firmware
  '';

  meta.platforms = [ "x86_64-freebsd" ];
  meta.license = lib.licenses.unfreeRedistributableFirmware;
  meta.sourceProvenance = [ lib.sourceTypes.binaryFirmware ];
}
