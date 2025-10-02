{
  mkDerivation,
  include,
  rpcgen,
  flex,
  byacc,
  gencat,
  csu,
  i18n,
  extraSrc ? [ ],
}:

mkDerivation {
  pname = "libcMinimal";
  path = "lib/libc";
  extraPaths = [
    "lib/libc_nonshared"
    "lib/msun"
    "lib/libmd"
    "lib/libutil"
    "libexec/rtld-elf"
    "include/rpcsvc"
    "contrib/libc-pwcache"
    "contrib/libc-vis"
    "contrib/tzcode"
    "contrib/gdtoa"
    "contrib/jemalloc"
    "sys/sys"
    "sys/kern"
    "sys/libkern"
    "sys/crypto"
    "sys/opencrypto"
    "etc/group"
    "etc/master.passwd"
    "etc/shells"
    "include/paths.h"
  ]
  ++ extraSrc;

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    include
  ];

  extraNativeBuildInputs = [
    rpcgen
    flex
    byacc
    gencat
  ];

  # this target is only used in the rtld-elf derivation. build it there instead.
  #
  # WE SHOULD REALLY BE REPLACING /usr/lib/i18n WITH THE libiconvModules DERIVATION
  # but this causes some awful dependency loops which basically collapse the entire libc derivation
  # instead, set the PATH_I18NMODULE environment variable whenever possible
  postPatch = ''
    sed -E -i -e '/BUILD_NOSSP_PIC_ARCHIVE=/d' $BSDSRCDIR/lib/libc/Makefile
    substituteInPlace $BSDSRCDIR/include/paths.h --replace '/usr/share/i18n' '${i18n}/share/i18n'
  '';

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  postBuild = ''
    make -C $BSDSRCDIR/lib/libc_nonshared $makeFlags
  '';

  postInstall = ''
    make -C $BSDSRCDIR/lib/libc_nonshared $makeFlags install
  '';

  alwaysKeepStatic = true;

  env = {
    MK_TESTS = "no";
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
    MK_MALLOC_PRODUCTION = "yes";
    MK_MACHDEP_OPTIMIZATIONS = "yes";
  };

  # definitely a bad idea to enable stack protection on the stack protection initializers
  hardeningDisable = [ "stackprotector" ];
}
