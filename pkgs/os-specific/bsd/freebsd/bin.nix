{ mkDerivation, pkgsBuildBuild, buildPackages, buildFreebsd, libjail, libmd, libnetbsd, libcapsicum, libcasper, libelf, libxo, libncurses-tinfo, libedit, libkvm, lib, stdenv, ...}:
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

  clangFixup = true;
  preBuild = ''
    export NIX_CFLAGS_COMPILE="-I$BSDSRCDIR/sys $NIX_CFLAGS_COMPILE"

    make -C $BSDSRCDIR/lib/libsm $makeFlags

    make -C $BSDSRCDIR/bin/sh $makeFlags "CC=${pkgsBuildBuild.stdenv.cc}/bin/cc" CFLAGS="-D__unused= -D__printf0like\(a,b\)= -D__dead2=" ${lib.optionalString (!stdenv.buildPlatform.isFreeBSD) "MK_PIE=no "}mkbuiltins mksyntax mktokens mknodes
    make -C $BSDSRCDIR/bin/csh $makeFlags "CC=${pkgsBuildBuild.stdenv.cc}/bin/cc" CFLAGS="-D__unused= -D__printf0like\(a,b\)= -D__dead2= -I$BSDSRCDIR/contrib/tcsh -I." ${lib.optionalString (!stdenv.buildPlatform.isFreeBSD) "MK_PIE=no "}gethost
  '';

  preInstall = ''
    makeFlags="$makeFlags ROOTDIR=$out/root"
  '';
}
