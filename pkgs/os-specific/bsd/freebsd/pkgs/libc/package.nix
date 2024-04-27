{ lib, stdenv, mkDerivation

, bsdSetupHook, freebsdSetupHook
, makeMinimal
, install
, flex, byacc, gencat, rpcgen

, csu, include
}:

mkDerivation rec {
  pname = "libc";
  path = "lib/libc";
  extraPaths = [
    "etc/group"
    "etc/master.passwd"
    "etc/shells"
    "lib/libmd"
    "lib/libutil"
    "lib/msun"
    "sys/kern"
    "sys/libkern"
    "sys/sys"
    "sys/crypto/chacha20"
    "include/rpcsvc"
    "contrib/jemalloc"
    "contrib/gdtoa"
    "contrib/libc-pwcache"
    "contrib/libc-vis"
    "contrib/tzcode/stdtime"

    # libthr
    "lib/libthr"
    "lib/libthread_db"
    "libexec/rtld-elf"

    # librpcsvc
    "lib/librpcsvc"

    # librt
    "lib/librt"

    # libcrypt
    "lib/libcrypt"
    "lib/libmd"
    "sys/crypto/sha2"
  ];

  patches = [
    # Hack around broken propogating MAKEFLAGS to submake, just inline logic
    ./libc-msun-arch-subdir.patch

    # Don't force -lcompiler-rt, we don't actually call it that
    ./libc-no-force--lcompiler-rt.patch

    # Fix extra include dir to get rpcsvc headers.
    ./librpcsvc-include-subdir.patch
  ];

  postPatch = ''
    substituteInPlace $COMPONENT_PATH/Makefile --replace '.include <src.opts.mk>' ""
  '';

  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal
    install

    flex byacc gencat rpcgen
  ];
  buildInputs = [ include csu ];
  env.NIX_CFLAGS_COMPILE = "-B${csu}/lib";

  # Suppress lld >= 16 undefined version errors
  # https://github.com/freebsd/freebsd-src/commit/2ba84b4bcdd6012e8cfbf8a0d060a4438623a638
  env.NIX_LDFLAGS = lib.optionalString (stdenv.targetPlatform.linker == "lld") "--undefined-version";

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    # lib/libc/gen/getgrent.c has sketchy cast from `void *` to enum
    "MK_WERROR=no"
  ];

  MK_SYMVER = "yes";
  MK_SSP = "yes";
  MK_NLS = "yes";
  MK_ICONV = "no"; # TODO make srctop
  MK_NS_CACHING = "yes";
  MK_INET6_SUPPORT = "yes";
  MK_HESIOD = "yes";
  MK_NIS = "yes";
  MK_HYPERV = "yes";
  MK_FP_LIBC = "yes";

  MK_TCSH = "no";
  MK_MALLOC_PRODUCTION = "yes";

  MK_TESTS = "no";

  postInstall = ''
    pushd ${include}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    pushd ${csu}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    sed -i -e 's| [^ ]*/libc_nonshared.a||' $out/lib/libc.so

    $CC -nodefaultlibs -lgcc -shared -o $out/lib/libgcc_s.so

    NIX_CFLAGS_COMPILE+=" -B$out/lib"
    NIX_CFLAGS_COMPILE+=" -I$out/include"
    NIX_LDFLAGS+=" -L$out/lib"

    make -C $BSDSRCDIR/lib/libthr $makeFlags
    make -C $BSDSRCDIR/lib/libthr $makeFlags install

    make -C $BSDSRCDIR/lib/msun $makeFlags
    make -C $BSDSRCDIR/lib/msun $makeFlags install

    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags
    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags install

    make -C $BSDSRCDIR/lib/libutil $makeFlags
    make -C $BSDSRCDIR/lib/libutil $makeFlags install

    make -C $BSDSRCDIR/lib/librt $makeFlags
    make -C $BSDSRCDIR/lib/librt $makeFlags install

    make -C $BSDSRCDIR/lib/libcrypt $makeFlags
    make -C $BSDSRCDIR/lib/libcrypt $makeFlags install
  '';

  meta.platforms = lib.platforms.freebsd;
}
