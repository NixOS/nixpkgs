{ mkDerivation, pkgsBuildBuild, buildPackages, buildFreebsd, libjail, libmd, libnetbsd, libcapsicum, libcasper, libelf, libxo, libncurses-tinfo, libedit, libkvm, ...}:
mkDerivation {
  pname = "bins";
  path = "bin";
  extraPaths = [/*"sbin" "usr.bin" "usr.sbin"*/ "sys/conf" "sys/sys/param.h" "contrib/sendmail" "contrib/tcsh" "usr.bin/printf" "lib/libsm"];
  buildInputs = [libjail libmd libnetbsd libcapsicum libcasper libelf libxo libncurses-tinfo libedit libkvm];
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

  preBuild = ''
    export NIX_CFLAGS_COMPILE="-I$BSDSRCDIR/sys $NIX_CFLAGS_COMPILE -D_WCHAR_T -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T"
    make -C $BSDSRCDIR/lib/libsm $makeFlags

    make -C $BSDSRCDIR/bin/sh $makeFlags "CC=${pkgsBuildBuild.clang}/bin/clang" CFLAGS="-D__unused= -D__printf0like\(a,b\)= -D__dead2=" mkbuiltins mksyntax mktokens mknodes
    make -C $BSDSRCDIR/bin/csh $makeFlags "CC=${pkgsBuildBuild.clang}/bin/clang" CFLAGS="-D__unused= -D__printf0like\(a,b\)= -D__dead2= -I$BSDSRCDIR/contrib/tcsh -I." gethost
  '';

  preInstall = ''
    makeFlags="$makeFlags ROOTDIR=$out/root"
  '';
}
