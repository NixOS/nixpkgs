{
  lib,
  stdenv,
  mkDerivation,
  versionData,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  boot-install,
  which,
  freebsd-lib,
  expat,
  zlib,
  extraSrc ? [ ],
}:

let
  inherit (freebsd-lib) mkBsdMachine;
in

mkDerivation {
  pname = "compat";
  path = "tools/build";
  extraPaths = [
    "lib/libc/db"
    "lib/libc/stdlib" # getopt
    "lib/libc/gen" # getcap
    "lib/libc/locale" # rpmatch
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "lib/libc/string" # strlcpy
    "lib/libutil"
  ]
  ++ [
    "contrib/libc-pwcache"
    "contrib/libc-vis"
    "sys/libkern"
    "sys/kern/subr_capability.c"

    # Take only individual headers, or else we will clobber native libc, etc.

    "sys/rpc/types.h"
  ]
  ++ lib.optionals (versionData.major >= 14) [
    "sys/sys/bitcount.h"
    "sys/sys/linker_set.h"
    "sys/sys/module.h"
  ]
  ++ [
    # Listed in Makekfile as INC
    "include/mpool.h"
    "include/ndbm.h"
    "include/err.h"
    "include/stringlist.h"
    "include/a.out.h"
    "include/nlist.h"
    "include/db.h"
    "include/getopt.h"
    "include/nl_types.h"
    "include/elf.h"
    "sys/sys/ctf.h"
  ]
  ++ lib.optionals (versionData.major >= 14) [
    "include/bitstring.h"
    "sys/sys/bitstring.h"
    "sys/sys/nv_namespace.h"
  ]
  ++ [

    # Listed in Makefile as SYSINCS

    "sys/sys/capsicum.h"
    "sys/sys/caprights.h"
    "sys/sys/imgact_aout.h"
    "sys/sys/nlist_aout.h"
    "sys/sys/nv.h"
    "sys/sys/dnv.h"
    "sys/sys/cnv.h"

    "sys/sys/elf32.h"
    "sys/sys/elf64.h"
    "sys/sys/elf_common.h"
    "sys/sys/elf_generic.h"
    "sys/${mkBsdMachine stdenv}/include"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [ "sys/x86/include" ]
  ++ [

    "sys/sys/queue.h"
    "sys/sys/md5.h"
    "sys/sys/sbuf.h"
    "sys/sys/tree.h"
    "sys/sys/font.h"
    "sys/sys/consio.h"
    "sys/sys/fnv_hash.h"
    #"sys/sys/cdefs.h"
    #"sys/sys/param.h"
    "sys/sys/_null.h"
    #"sys/sys/types.h"
    "sys/sys/_pthreadtypes.h"
    "sys/sys/_stdint.h"

    "sys/crypto/chacha20/_chacha.h"
    "sys/crypto/chacha20/chacha.h"
    # included too, despite ".c"
    "sys/crypto/chacha20/chacha.c"

    "sys/fs"
    "sys/ufs"
    "sys/sys/disk"

    "lib/libcapsicum"
    "lib/libcasper"
    "lib/libmd"

    # idk bro
    "sys/sys/kbio.h"
  ]
  ++ extraSrc;

  preBuild = ''
    NIX_CFLAGS_COMPILE+=' -I../../include -I../../sys'

    cp ../../sys/${mkBsdMachine stdenv}/include/elf.h ../../sys/sys
    cp ../../sys/${mkBsdMachine stdenv}/include/elf.h ../../sys/sys/${mkBsdMachine stdenv}
  ''
  + lib.optionalString stdenv.hostPlatform.isx86 ''
    cp ../../sys/x86/include/elf.h ../../sys/x86
  '';

  setupHooks = [
    ../../../../../build-support/setup-hooks/role.bash
    ./compat-setup-hook.sh
  ];

  # This one has an ifdefed `#include_next` that makes it annoying.
  postInstall = ''
    rm ''${!outputDev}/0-include/libelf.h
  '';

  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    boot-install

    which
  ];
  buildInputs = [
    expat
    zlib
  ];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
    "HOST_INCLUDE_ROOT=${lib.getDev stdenv.cc.libc}/include"
    "INSTALL=boot-install"
  ];

  preIncludes = ''
    mkdir -p $out/{0,1}-include
    cp --no-preserve=mode -r cross-build/include/common/* $out/0-include
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp --no-preserve=mode -r cross-build/include/linux/* $out/1-include
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp --no-preserve=mode -r cross-build/include/darwin/* $out/1-include
  '';

  # Compat is for making other platforms look like FreeBSD (e.g. to
  # build build-time dependencies for building FreeBSD packages). It is
  # not needed when building for FreeBSD.
  meta.platforms = lib.platforms.linux;

  alwaysKeepStatic = true;
}
