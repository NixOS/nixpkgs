{
  lib,
  mkDerivation,
  sys,
  buildFreebsd,
  linux-firmware,
}:
mkDerivation rec {
  # out-of-tree, but we still want to use freebsd.mkDerivation, which wants an in-tree path
  path = "...";

  pname = "iwlwifi-firmware";
  version = linux-firmware.version;

  # Upstream FreeBSD doesn't wrap wifi firmware, only gpu firmware.
  # We have to write our own build scripts for this.
  src = ./src;

  outputs = [
    "out"
    "debug"
  ];

  extraNativeBuildInputs = [ buildFreebsd.xargs-j ];

  env = sys.passthru.env;
  SYSDIR = "${sys.src}/sys";
  KERN_DEBUGDIR = "${builtins.placeholder "debug"}/lib/debug";
  KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
  KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";
  KMODDIR = "${placeholder "out"}/kernel";

  LINUX_FIRMWARE = "${linux-firmware}/lib/firmware";

  # generates relocations the linker can't handle
  hardeningDisable = [
    "pic"
  ];

  makeFlags = [
    "DEBUG_FLAGS=-g"
    "XARGS_J=xargs-j"
    "NO_XREF=1"
  ];

  preConfigure = ''
    bash gen-makefiles
  '';

  meta = {
    description = "Intel Wifi Firmware for FreeBSD";
    platforms = lib.platforms.freebsd;
    license = linux-firmware.meta.license;
  };
}
