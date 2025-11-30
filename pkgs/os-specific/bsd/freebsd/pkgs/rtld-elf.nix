{
  mkDerivation,
  fetchpatch,
  include,
  rpcgen,
  flex,
  byacc,
  csu,
  extraSrc ? [ ],
}:

mkDerivation {
  path = "libexec/rtld-elf";
  extraPaths = [
    "lib/csu"
    "lib/libc"
    "lib/libmd"
    "lib/msun"
    "lib/libutil"
    "lib/libc_nonshared"
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
  ]
  ++ extraSrc;

  patches = [
    # https://github.com/freebsd/freebsd-src/pull/1882
    (fetchpatch {
      name = "freebsd-rtld-use-nonstring-attribute.patch";
      url = "https://github.com/freebsd/freebsd-src/pull/1882/commits/650800993deb513dc31e99ef5cdecd50ee70bb04.diff";
      hash = "sha256-V9jDE/5Fu6hLIzlG1e6AqLnGwlzW2OjonyUgvSVtm58=";
      includes = [ "libexec/rtld-elf/rtld.c" ];
    })
  ];

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
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
    make -C $BSDSRCDIR/lib/libc $makeFlags libc_nossp_pic.a
  '';

  # definitely a bad idea to enable stack protection on the stack protection initializers
  hardeningDisable = [ "stackprotector" ];

  env.MK_TESTS = "no";
}
