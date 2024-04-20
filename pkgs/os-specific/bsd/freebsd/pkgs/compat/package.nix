{ lib, stdenv, mkDerivation
, bsdSetupHook, freebsdSetupHook
, makeMinimal, boot-install
, which
, freebsd-lib
, expat, zlib,
}:

let
  inherit (freebsd-lib) mkBsdArch;
in

mkDerivation rec {
  pname = "compat";
  path = "tools/build";
  extraPaths = [
    "lib/libc/db"
    "lib/libc/stdlib" # getopt
    "lib/libc/gen" # getcap
    "lib/libc/locale" # rpmatch
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    "lib/libc/string" # strlcpy
    "lib/libutil"
  ] ++ [
    "contrib/libc-pwcache"
    "contrib/libc-vis"
    "sys/libkern"
    "sys/kern/subr_capability.c"

    # Take only individual headers, or else we will clobber native libc, etc.

    "sys/rpc/types.h"

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

    # Listed in Makekfile as SYSINC

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
    "sys/${mkBsdArch stdenv}/include"
  ] ++ lib.optionals stdenv.hostPlatform.isx86 [
    "sys/x86/include"
  ] ++ [

    "sys/sys/queue.h"
    "sys/sys/md5.h"
    "sys/sys/sbuf.h"
    "sys/sys/tree.h"
    "sys/sys/font.h"
    "sys/sys/consio.h"
    "sys/sys/fnv_hash.h"

    "sys/crypto/chacha20/_chacha.h"
    "sys/crypto/chacha20/chacha.h"
    # included too, despite ".c"
    "sys/crypto/chacha20/chacha.c"

    "sys/fs"
    "sys/ufs"
    "sys/sys/disk"

    "lib/libcapsicum"
    "lib/libcasper"
  ];

  patches = [
    ./compat-install-dirs.patch
    ./compat-fix-typedefs-locations.patch
  ];

  preBuild = ''
    NIX_CFLAGS_COMPILE+=' -I../../include -I../../sys'

    cp ../../sys/${mkBsdArch stdenv}/include/elf.h ../../sys/sys
    cp ../../sys/${mkBsdArch stdenv}/include/elf.h ../../sys/sys/${mkBsdArch stdenv}
  '' + lib.optionalString stdenv.hostPlatform.isx86 ''
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
    bsdSetupHook freebsdSetupHook
    makeMinimal
    boot-install

    which
  ];
  buildInputs = [ expat zlib ];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
    "HOST_INCLUDE_ROOT=${lib.getDev stdenv.cc.libc}/include"
    "INSTALL=boot-install"
  ];

  preIncludes = ''
    mkdir -p $out/{0,1}-include
    cp --no-preserve=mode -r cross-build/include/common/* $out/0-include
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp --no-preserve=mode -r cross-build/include/linux/* $out/1-include
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp --no-preserve=mode -r cross-build/include/darwin/* $out/1-include
  '';
}
