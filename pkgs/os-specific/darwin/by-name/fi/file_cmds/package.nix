{
  lib,
  apple-sdk_26,
  bzip2,
  copyfile,
  less,
  libmd,
  libutil,
  libxo,
  mkAppleDerivation,
  ncurses,
  pkg-config,
  removefile,
  shell_cmds,
  sourceRelease,
  stdenvNoCC,
  xz,
  zlib,
}:

let
  Libc = sourceRelease "Libc";
  Libinfo = sourceRelease "Libinfo";
  CommonCrypto = sourceRelease "CommonCrypto";
  libplatform = sourceRelease "libplatform";
  xnu = sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "file_cmds-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include" \
        '${Libinfo}/membership.subproj/membershipPriv.h' \
        '${libplatform}/private/_simple.h'
      install -D -t "$out/include/os" \
        '${Libc}/os/assumes.h' \
        '${xnu}/libkern/os/base_private.h'
      install -D -t "$out/include/sys" \
        '${xnu}/bsd/sys/ipcs.h' \
        '${xnu}/bsd/sys/sem_internal.h' \
        '${xnu}/bsd/sys/shm_internal.h'
      install -D -t "$out/include/CommonCrypto" \
        '${CommonCrypto}/include/Private/CommonDigestSPI.h'
      install -D -t "$out/include/System/sys" \
        '${xnu}/bsd/sys/fsctl.h'

      mkdir -p "$out/include/apfs"
      # APFS group is 'J' per https://github.com/apple-oss-distributions/xnu/blob/94d3b452840153a99b38a3a9659680b2a006908e/bsd/vfs/vfs_fsevents.c#L1054
      cat <<EOF > "$out/include/apfs/apfs_fsctl.h"
      #pragma once
      #include <stdint.h>
      #include <sys/ioccom.h>
      struct xdstream_obj_id {
        char* xdi_name;
        uint64_t xdi_xdtream_obj_id;
      };
      #define APFS_CLEAR_PURGEABLE 0
      #define APFS_PURGEABLE_FLAGS_MASK 0xFFFF
      #define APFSIOC_GET_PURGEABLE_FILE_FLAGS _IOR('J', 71, uint64_t)
      #define APFSIOC_MARK_PURGEABLE _IOWR('J', 68, uint64_t)
      #define APFSIOC_XDSTREAM_OBJ_ID _IOWR('J', 53, struct xdstream_obj_id)
      EOF

      cat <<EOF > "$out/include/sys/types.h"
      #pragma once
      #include <stdint.h>
      #if defined(__arm64__)
      /* https://github.com/apple-oss-distributions/xnu/blob/94d3b452840153a99b38a3a9659680b2a006908e/bsd/arm/types.h#L120-L133 */
      typedef int32_t user32_addr_t;
      typedef int32_t user32_time_t;
      typedef int64_t user64_addr_t;
      typedef int64_t user64_time_t;
      #elif defined(__x86_64__)
      /* https://github.com/apple-oss-distributions/xnu/blob/94d3b452840153a99b38a3a9659680b2a006908e/bsd/i386/types.h#L128-L142 */
      typedef int32_t user32_addr_t;
      typedef int32_t user32_time_t;
      typedef int64_t user64_addr_t __attribute__((aligned(8)));
      typedef int64_t user64_time_t __attribute__((aligned(8)));
      #else
      #error "Tried to build file_cmds for an unsupported architecture"
      #endif
      #include_next <sys/types.h>
      EOF
    '';
  };
in
mkAppleDerivation {
  releaseName = "file_cmds";

  outputs = [
    "out"
    "man"
    "xattr"
  ];

  xcodeHash = "sha256-O1eJGFrSVIZbZvBSonKkG4MeYZQ8W6izpYEcHIE+/DM=";

  patches = [
    # `O_RESOLVE_BENEATH` was added in macOS 26, but our default deployment target is older than that.
    # Make its usage conditional.
    ./patches/0001-Conditionalize-O_RESOLVE_BENEATH-usage.patch
  ];

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    apple-sdk_26 # For `O_RESOLVE_BENEATH` and `AT_RESOLVE_BENEATH`
    bzip2
    copyfile
    libmd
    libutil
    libxo
    ncurses
    removefile
    xz
    zlib
  ];

  postInstall = ''
    HOST_PATH='${lib.getBin shell_cmds}/bin' patchShebangs --host "$out/bin"

    substituteInPlace "$out/bin/zmore" \
      --replace-fail 'PAGER-less' '${lib.getBin less}/bin/less' \
      --replace-fail 'PAGER-more' '${lib.getBin less}/bin/more'

    # Work around Meson limitations.
    mv "$out/bin/install-bin" "$out/bin/install"

    # Make xattr available in its own output, so darwin.xattr can be an alias to it.
    moveToOutput bin/xattr "$xattr"
    ln -s "$xattr/bin/xattr" "$out/bin/xattr"
  '';

  meta = {
    description = "File commands for Darwin";
    license = with lib.licenses; [
      apple-psl10
      bsd2
      # bsd2-freebsd
      # bsd2-netbsd
      bsd3
      bsdOriginal
      mit
    ];
  };
}
