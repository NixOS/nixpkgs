{
  lib,
  apple-sdk,
  apple-sdk_11,
  libutil,
  mkAppleDerivation,
  removefile,
  stdenvNoCC,
}:

let
  Libc = apple-sdk_11.sourceRelease "Libc";
  xnu = apple-sdk_11.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "diskdev_cmds-deps-private-headers";

    buildCommand = ''
      for dir in arm i386 machine sys; do
        install -D -t "$out/include/$dir" '${xnu}'"/bsd/$dir/disklabel.h"
      done
      install -D -t "$out/include/os" \
        '${Libc}/os/api.h' \
        '${Libc}/os/variant_private.h' \
        '${Libc}/libdarwin/h/bsd.h' \
        '${Libc}/libdarwin/h/errno.h'
      install -D -t "$out/include/System/sys" \
        '${xnu}/bsd/sys/fsctl.h' \
        '${xnu}/bsd/sys/reason.h'
      install -D -t "$out/include/System/uuid" \
        '${Libc}/uuid/namespace.h'
      mkdir -p "$out/include/APFS"
      touch "$out/include/APFS/APFS.h"
      touch "$out/include/APFS/APFSConstants.h"

      substituteInPlace "$out/include/os/variant_private.h" \
        --replace-fail ', bridgeos(4.0)' "" \
        --replace-fail ', bridgeos' ""
    '';
  };
in
mkAppleDerivation {
  releaseName = "diskdev_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-Y4Lrr6gtbMj6+HDqmT5A+t59EIE5u780+0fLKoXaiIo=";

  postPatch =
    # Fix incompatible pointer to integer conversion. The last parameter is size_t not a pointer.
    # https://developer.apple.com/documentation/kernel/1387446-sysctlbyname
    ''
      substituteInPlace mount.tproj/mount.c \
        --replace-fail 'sysctlbyname ("vfs.generic.apfs.rosp", &is_rosp, &rospsize, NULL, NULL);' 'sysctlbyname ("vfs.generic.apfs.rosp", &is_rosp, &rospsize, NULL, 0);'
    ''
    # The first reserved uint32 is used for the extended flags on 11.0 and newer, and
    # only use sysexit_np when the version is 10.14 or newer.
    + lib.optionalString (lib.versionOlder (lib.getVersion apple-sdk) "11.0") ''
      substituteInPlace mount.tproj/mount.c \
        --replace-fail 'sfp->f_flags_ext' 'sfp->f_reserved[0]' \
        --replace-fail 'sysexit == -1' '__builtin_available(macOS 10.14, *) && sysexit == -1'
    '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    apple-sdk.privateFrameworksHook
    libutil
    removefile
  ];

  meta.description = "Disk commands for Darwin";
}
