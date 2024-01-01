{ hostVersion, lib, stdenv, mkDerivation, buildPackages, buildFreebsd, hostArchBsd, ... }:
mkDerivation {
  path = "stand/efi";
  #extraPaths = ["sys" "lib/libc" "contrib/llvm-project/compiler-rt/lib/builtins"];
  extraPaths = ["."];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff
    buildFreebsd.vtfontcvt
  ];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_MAN=no"
    "MK_TESTS=no"
    "OBJCOPY=${lib.getBin buildPackages.binutils-unwrapped}/bin/${buildPackages.binutils-unwrapped.targetPrefix}objcopy"
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no"
  ++ lib.optionals (true && stdenv.targetPlatform.isx86_64) [
    "LIBS32=${lib.getLib ((import ../../../.. {
      crossSystem = {
        config = "i686-${hostVersion}";
        useLLVM = true;
      };
      localSystem = stdenv.buildPlatform;
    }).llvmPackages_16.libunwind.override { enableShared = false; })}/lib"
  ]
  ;

  hardeningDisable = [ "stackprotector" ];

  # ???
  preBuild = ''
    mkdir $BSDSRCDIR/xinclude
    ln -s ../include/{string.h,strings.h,xlocale,stdbool.h,uuid.h,assert.h} $BSDSRCDIR/xinclude
    touch $BSDSRCDIR/xinclude/stdio.h $BSDSRCDIR/xinclude/stdlib.h
    NIX_CFLAGS_COMPILE+=" -I$BSDSRCDIR/xinclude -I$BSDSRCDIR/sys/sys -I$BSDSRCDIR/sys/${hostArchBsd}/include"
    export NIX_CFLAGS_COMPILE

    make -C $BSDSRCDIR/stand/libsa $makeFlags
    make -C $BSDSRCDIR/stand/ficl $makeFlags
    make -C $BSDSRCDIR/stand/liblua $makeFlags
  '';

  postPatch = ''
    sed -E -i -e 's|/bin/pwd|${buildPackages.coreutils}/bin/pwd|' $BSDSRCDIR/stand/defs.mk
    #sed -E -i -e 's|-e start|-Wl,-e,start|g' $BSDSRCDIR/stand/i386/Makefile.inc $BSDSRCDIR/stand/i386/*/Makefile
  '';

  postInstall = ''
    mkdir -p $out/bin/lua
    cp $BSDSRCDIR/stand/lua/*.lua $out/bin/lua
    cp -r $BSDSRCDIR/stand/defaults $out/bin/defaults
  '';
}
