{ libc, mkDerivation, buildPackages, buildFreebsd, libjail, libmd, libnetbsd, libcapsicum, libcasper, libelf, libxo, libncurses-tinfo, libedit, lib, stdenv, ...}:
mkDerivation {
  pname = "bins";
  path = "bin";
  extraPaths = [/*"sbin" "usr.bin" "usr.sbin"*/ "sys/conf" "sys/sys/param.h" "contrib/sendmail" "contrib/tcsh" "usr.bin/printf" "lib/libsm"];
  buildInputs = [libjail libmd libnetbsd libcapsicum libcasper libelf libxo libncurses-tinfo libedit libc]; # ??? why libc
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook

    buildPackages.yacc
    buildFreebsd.gencat
  ];

  MK_TESTS = "no";

  postPatch = ''
    sed -E -i -e '/#define\tBSD.*/d' $BSDSRCDIR/sys/sys/param.h
    sed -E -i -e '/^SYMLINKS.*/d' $BSDSRCDIR/bin/*/Makefile
    sed -E -i -e 's/mktemp -t ka/mktemp -t kaXXXXXX/' $BSDSRCDIR/bin/sh/mkbuiltins $BSDSRCDIR/bin/sh/mktokens
  '';

  preBuild = lib.optionalString stdenv.cc.isClang ''
    #export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED -D_SIZE_T -D_WCHAR_T"
  '' + ''
    export NIX_CFLAGS_COMPILE="-I$BSDSRCDIR/sys $NIX_CFLAGS_COMPILE"
    make -C $BSDSRCDIR/lib/libsm $makeFlags
  '';

  preInstall = ''
    makeFlags="$makeFlags -j1"
  '';

  #postBuild = ''
  #  make -C $BSDSRCDIR/sbin $makeFlags
  #  make -C $BSDSRCDIR/usr.bin $makeFlags
  #  make -C $BSDSRCDIR/usr.sbin $makeFlags
  #'';

  #postInstall = ''
  #  make -C $BSDSRCDIR/sbin $makeFlags install
  #  make -C $BSDSRCDIR/usr.bin $makeFlags install
  #  make -C $BSDSRCDIR/usr.sbin $makeFlags install
  #'';
}
