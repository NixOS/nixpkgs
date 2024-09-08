{
  lib,
  buildPackages,
  stdenv,
  mkDerivation,

  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  flex,
  byacc,
  gencat,
  rpcgen,
  mkcsmapper,
  mkesdb,

  csu,
  include,
  versionData,
}:

mkDerivation {
  noLibc = true;
  pname = "libc";
  path = "lib/libc";
  extraPaths =
    [
      "lib/libc_nonshared"
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
    ]
    ++ lib.optionals (versionData.major == 13) [ "contrib/tzcode/stdtime" ]
    ++ lib.optionals (versionData.major == 14) [ "contrib/tzcode" ]
    ++ [

      # libthr
      "lib/libthr"
      "lib/libthread_db"
      "libexec/rtld-elf"
      "lib/csu/common/crtbrand.S"
      "lib/csu/common/notes.h"

      # librpcsvc
      "lib/librpcsvc"

      # librt
      "lib/librt"

      # libcrypt
      "lib/libcrypt"
      "lib/libmd"
      "sys/crypto/sha2"
      "sys/crypto/skein"

      # libgcc and friends
      "lib/libgcc_eh"
      "lib/libgcc_s"
      "lib/libcompiler_rt"
      "contrib/llvm-project/libunwind"
      "contrib/llvm-project/compiler-rt"
      #"contrib/llvm-project/libcxx"

      # terminfo
      "lib/ncurses"
      "contrib/ncurses"
      "lib/Makefile.inc"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isx86_32) [ "lib/libssp_nonshared" ]
    ++ [
      "lib/libexecinfo"
      "contrib/libexecinfo"

      "lib/libkvm"
      "sys" # ummmmmmmmmm libkvm wants arch-specific headers from the kernel tree

      "lib/libmemstat"

      "lib/libprocstat"
      "sys/contrib/openzfs"
      "sys/contrib/pcg-c"
      "sys/opencrypto"
      "sys/contrib/ck"
      "sys/crypto"

      "lib/libdevstat"

      "lib/libelf"
      "contrib/elftoolchain"

      "lib/libiconv_modules"
      "share/i18n"
      "include/paths.h"

      "lib/libdl"
    ];

  postPatch = ''
    substituteInPlace $COMPONENT_PATH/Makefile --replace '.include <src.opts.mk>' ""

    substituteInPlace $BSDSRCDIR/include/paths.h \
        --replace '/usr/lib/i18n' '${builtins.placeholder "out"}/lib/i18n' \
        --replace '/usr/share/i18n' '${builtins.placeholder "out"}/share/i18n'
  '';

  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    install

    flex
    byacc
    gencat
    rpcgen
    mkcsmapper
    mkesdb
  ];
  buildInputs = [
    include
    csu
  ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-B${csu}/lib"
    # These are supposed to have _RTLD_COMPAT_LIB_SUFFIX so we can get things like "lib32"
    # but that's unnecessary
    "-DSTANDARD_LIBRARY_PATH=\"${builtins.placeholder "out"}/lib\""
    "-D_PATH_RTLD=\"${builtins.placeholder "out"}/libexec/ld-elf.so.1\""
  ];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    # lib/libc/gen/getgrent.c has sketchy cast from `void *` to enum
    "MK_WERROR=no"
  ];

  MK_SYMVER = "yes";
  MK_SSP = "yes";
  MK_NLS = "yes";
  MK_ICONV = "yes";
  MK_NS_CACHING = "yes";
  MK_INET6_SUPPORT = "yes";
  MK_HESIOD = "yes";
  MK_NIS = "yes";
  MK_HYPERV = "yes";
  MK_FP_LIBC = "yes";

  MK_TCSH = "no";
  MK_MALLOC_PRODUCTION = "yes";

  MK_TESTS = "no";
  MACHINE_ABI = "";
  MK_DETECT_TZ_CHANGES = "no";
  MK_MACHDEP_OPTIMIZATIONS = "yes";
  MK_ASAN = "no";
  MK_UBSAN = "no";

  NO_FSCHG = "yes";

  preBuild = lib.optionalString (stdenv.hostPlatform.isx86_32) ''
    make -C $BSDSRCDIR/lib/libssp_nonshared $makeFlags
    make -C $BSDSRCDIR/lib/libssp_nonshared $makeFlags install
  '';

  postInstall =
    ''
      pushd ${include}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      pushd ${csu}
      find . -type d -exec mkdir -p $out/\{} \;
      find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
      popd

      mkdir $BSDSRCDIR/lib/libcompiler_rt/i386 $BSDSRCDIR/lib/libcompiler_rt/cpu_model
      make -C $BSDSRCDIR/lib/libcompiler_rt $makeFlags
      make -C $BSDSRCDIR/lib/libcompiler_rt $makeFlags install

      make -C $BSDSRCDIR/lib/libgcc_eh $makeFlags
      make -C $BSDSRCDIR/lib/libgcc_eh $makeFlags install

      ln -s $BSDSRCDIR/lib/libc/libc.so.7 $BSDSRCDIR/lib/libc/libc.so  # not sure
      mkdir $BSDSRCDIR/lib/libgcc_s/i386 $BSDSRCDIR/lib/libgcc_s/cpu_model
      make -C $BSDSRCDIR/lib/libgcc_s $makeFlags
      make -C $BSDSRCDIR/lib/libgcc_s $makeFlags install

      NIX_CFLAGS_COMPILE+=" -B$out/lib"
      NIX_CFLAGS_COMPILE+=" -I$out/include"
      NIX_LDFLAGS+=" -L$out/lib"

      make -C $BSDSRCDIR/lib/libc_nonshared $makeFlags
      make -C $BSDSRCDIR/lib/libc_nonshared $makeFlags install

      mkdir $BSDSRCDIR/lib/libmd/sys
      make -C $BSDSRCDIR/lib/libmd $makeFlags
      make -C $BSDSRCDIR/lib/libmd $makeFlags install

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

      make -C $BSDSRCDIR/lib/libelf $makeFlags
      make -C $BSDSRCDIR/lib/libelf $makeFlags install

      make -C $BSDSRCDIR/lib/libexecinfo $makeFlags
      make -C $BSDSRCDIR/lib/libexecinfo $makeFlags install

      make -C $BSDSRCDIR/lib/libkvm $makeFlags
      make -C $BSDSRCDIR/lib/libkvm $makeFlags install

      make -C $BSDSRCDIR/lib/libmemstat $makeFlags
      make -C $BSDSRCDIR/lib/libmemstat $makeFlags install

      make -C $BSDSRCDIR/lib/libprocstat $makeFlags
      make -C $BSDSRCDIR/lib/libprocstat $makeFlags install

      make -C $BSDSRCDIR/lib/libdevstat $makeFlags
      make -C $BSDSRCDIR/lib/libdevstat $makeFlags install

      make -C $BSDSRCDIR/lib/libiconv_modules $makeFlags
      make -C $BSDSRCDIR/lib/libiconv_modules $makeFlags SHLIBDIR=${builtins.placeholder "out"}/lib/i18n install

      make -C $BSDSRCDIR/lib/libdl $makeFlags
      make -C $BSDSRCDIR/lib/libdl $makeFlags install

      make -C $BSDSRCDIR/share/i18n $makeFlags
      make -C $BSDSRCDIR/share/i18n $makeFlags ESDBDIR=${builtins.placeholder "out"}/share/i18n/esdb CSMAPPERDIR=${builtins.placeholder "out"}/share/i18n/csmapper install

    ''
    + lib.optionalString stdenv.hostPlatform.isx86_32 ''
      $CC -c $BSDSRCDIR/contrib/llvm-project/compiler-rt/lib/builtins/udivdi3.c -o $BSDSRCDIR/contrib/llvm-project/compiler-rt/lib/builtins/udivdi3.o
      ORIG_NIX_LDFLAGS="$NIX_LDFLAGS"
      NIX_LDFLAGS+=" $BSDSRCDIR/contrib/llvm-project/compiler-rt/lib/builtins/udivdi3.o"
    ''
    + ''
      make -C $BSDSRCDIR/libexec/rtld-elf $makeFlags
      make -C $BSDSRCDIR/libexec/rtld-elf $makeFlags install
      rm -f $out/libexec/ld-elf.so.1
      mv $out/bin/ld-elf.so.1 $out/libexec
    '';

  # libc should not be allowed to refer to anything other than itself
  postFixup = ''
    find $out -type f | xargs -n1 ${buildPackages.patchelf}/bin/patchelf --shrink-rpath --allowed-rpath-prefixes $out || true
  '';

  meta.platforms = lib.platforms.freebsd;

  # definitely a bad idea to enable stack protection on the stack protection initializers
  hardeningDisable = [ "stackprotector" ];

  outputs = [
    "out"
    "man"
    "debug"
  ];
}
