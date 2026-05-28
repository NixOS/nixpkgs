{
  mkDerivation,
  fetchpatch,
  include,
  rpcgen,
  libsys,
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
    "lib/libsys"
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
    "include/gssapi"
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
    libsys
  ];

  extraNativeBuildInputs = [
    rpcgen
    flex
    byacc
  ];

  # see comment in libc-minimal about -fno-blocks
  preBuild = ''
    ln -s ${libsys}/lib/libsys_pic.a ../../lib/libsys/libsys_pic.a
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fno-blocks -B${csu}/lib"
    make -C $BSDSRCDIR/lib/libc $makeFlags libc_nossp_pic.a
  '';

  # freebsd does not do this link correctly if the target is the nix store
  postInstall = ''
    ln -sf $out/bin/ld-elf.so.1 $out/libexec/ld-elf.so.1
  '';

  # definitely a bad idea to enable stack protection on the stack protection initializers
  # no fortify because then it pulls in __whatever_chk functions which are not built bc no ssp
  hardeningDisable = [
    "stackprotector"
    "fortify"
  ];

  env.MK_TESTS = "no";
}
