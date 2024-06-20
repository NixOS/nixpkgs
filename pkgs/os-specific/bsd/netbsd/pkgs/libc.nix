{
  lib,
  mkDerivation,
  defaultMakeFlags,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  flex,
  byacc,
  genassym,
  gencat,
  lorder,
  tsort,
  statHook,
  rpcgen,
  csu,
  headers,
  librt,
}:

mkDerivation {
  noLibc = true;
  path = "lib/libc";
  outputs = [
    "out"
    "dev"
    "man"
    "tags"
  ];
  USE_FORT = "yes";
  MKPROFILE = "no";
  extraPaths = [
    "common"
    "lib/i18n_module"
    "lib/libcrypt"
    "lib/libm"
    "lib/libpthread"
    "lib/libresolv"
    "lib/librpcsvc"
    "lib/librt"
    "lib/libutil"
    "libexec/ld.elf_so"
    "sys"
    "external/bsd/jemalloc"
  ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    flex
    byacc
    genassym
    gencat
    lorder
    tsort
    statHook
    rpcgen
  ];
  buildInputs = [
    headers
    csu
  ];
  env.NIX_CFLAGS_COMPILE = "-B${csu}/lib -fcommon";
  meta.platforms = lib.platforms.netbsd;
  SHLIBINSTALLDIR = "$(out)/lib";
  MKPICINSTALL = "yes";
  NLSDIR = "$(out)/share/nls";
  makeFlags = defaultMakeFlags ++ [ "FILESDIR=$(out)/var/db" ];
  postInstall = ''
    pushd ${headers}
    find include -type d -exec mkdir -p "$dev/{}" ';'
    find include '(' -type f -o -type l ')' -exec cp -pr "{}" "$dev/{}" ';'
    popd

    pushd ${csu}
    find lib -type d -exec mkdir -p "$out/{}" ';'
    find lib '(' -type f -o -type l ')' -exec cp -pr "{}" "$out/{}" ';'
    popd

    NIX_CFLAGS_COMPILE+=" -B$out/lib"
    NIX_CFLAGS_COMPILE+=" -I$dev/include"
    NIX_LDFLAGS+=" -L$out/lib"

    make -C $BSDSRCDIR/lib/libpthread $makeFlags
    make -C $BSDSRCDIR/lib/libpthread $makeFlags install

    make -C $BSDSRCDIR/lib/libm $makeFlags
    make -C $BSDSRCDIR/lib/libm $makeFlags install

    make -C $BSDSRCDIR/lib/libresolv $makeFlags
    make -C $BSDSRCDIR/lib/libresolv $makeFlags install

    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags
    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags install

    make -C $BSDSRCDIR/lib/i18n_module $makeFlags
    make -C $BSDSRCDIR/lib/i18n_module $makeFlags install

    make -C $BSDSRCDIR/lib/libutil $makeFlags
    make -C $BSDSRCDIR/lib/libutil $makeFlags install

    make -C $BSDSRCDIR/lib/librt $makeFlags
    make -C $BSDSRCDIR/lib/librt $makeFlags install

    make -C $BSDSRCDIR/lib/libcrypt $makeFlags
    make -C $BSDSRCDIR/lib/libcrypt $makeFlags install

    moveToOutput var/db/libc.tags "$tags"
  '';
  postPatch = ''
    sed -i 's,/usr\(/include/sys/syscall.h\),${headers}\1,g' \
      $BSDSRCDIR/lib/{libc,librt}/sys/Makefile.inc
  '';
}
