{ mkDerivation, csu, include, buildPackages, buildFreebsd, lib, hostVersion, ... }:
mkDerivation rec {
  isStatic = true;
  pname = "libc";
  path = "lib/libc";
  extraPaths = [
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
  ] ++ lib.optionals (hostVersion == "freebsd13") [
    "contrib/tzcode/stdtime"
  ] ++ lib.optionals (hostVersion == "freebsd14") [
    "contrib/tzcode"
  ] ++ [

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
    #"lib/libgcc_eh"
    #"lib/libgcc_s"
    #"contrib/llvm-project/compiler-rt"
    #"contrib/llvm-project/libunwind"
    #"contrib/llvm-project/libcxx"
    #"lib/libcompiler_rt"

    # terminfo
    "lib/ncurses"
    "contrib/ncurses"
    "lib/Makefile.inc"
  ];

  patches = [
    # Hack around broken propogating MAKEFLAGS to submake, just inline logic
    ./libc-msun-arch-subdir.patch

    # Don't force -lcompiler-rt, we don't actually call it that
    ./libc-no-force--lcompiler-rt.patch
    ./rtld-no-force--lcompiler-rt.patch

    # Fix extra include dir to get rpcsvc headers.
    ./librpcsvc-include-subdir.patch
  ];

  postPatch = ''
    substituteInPlace $COMPONENT_PATH/Makefile --replace '.include <src.opts.mk>' ""
  '';

  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install

    buildPackages.flex buildPackages.byacc buildFreebsd.gencat buildFreebsd.rpcgen
  ];
  buildInputs = [ include csu ];
  env.NIX_CFLAGS_COMPILE = "-B${csu}/lib";

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

  postInstall = ''
    pushd ${include}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    pushd ${csu}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    mkdir -p $libgcc/lib
    $CC -nodefaultlibs -lgcc -shared -o $libgcc/lib/libgcc_s.so
    $AR r $libgcc/lib/libgcc_eh.a

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

    make -C $BSDSRCDIR/lib/ncurses/tinfo $makeFlags
    make -C $BSDSRCDIR/lib/ncurses/tinfo $makeFlags install

    make -C $BSDSRCDIR/libexec/rtld-elf $makeFlags
    make -C $BSDSRCDIR/libexec/rtld-elf $makeFlags install
    rm -f $out/libexec/ld-elf.so.1
    mv $out/bin/ld-elf.so.1 $out/libexec
  '';

  meta.platforms = lib.platforms.freebsd;

  # definitely a bad idea to enable stack protection on the stack protection initializers
  hardeningDisable = [ "stackprotector" ];

  outputs = ["out" "libgcc"];
}
