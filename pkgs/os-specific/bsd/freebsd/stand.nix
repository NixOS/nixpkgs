{ hostVersion, lib, stdenv, mkDerivation, buildPackages, buildFreebsd, patchesRoot, ... }:
mkDerivation {
  path = "stand";
  #extraPaths = ["sys" "lib/libc" "contrib/llvm-project/compiler-rt/lib/builtins"];
  extraPaths = ["."];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff
    buildFreebsd.vtfontcvt
    buildFreebsd.btxld
  ];

  patches = [ /${patchesRoot}/stand-libs32.patch ];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_MAN=no"
    "MK_TESTS=no"
    "OBJCOPY=${lib.getBin buildPackages.binutils-unwrapped}/bin/${buildPackages.binutils-unwrapped.targetPrefix}objcopy"
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no"
  ++ lib.optionals (true && stdenv.targetPlatform.isx86_64) [
    "LIBS32=${lib.getLib ((import ../../../.. { crossSystem = {
      config = "i686-${hostVersion}";
      useLLVM = true;
    #};}).llvmPackages_16.libunwind.override { enableShared = false; }).overrideAttrs { NIX_CFLAGS_COMPILE = "-Oz";}}/lib"
    };}).llvmPackages_16.libunwind.override { enableShared = false; })}/lib"
  ]
  ;

  hardeningDisable = [ "stackprotector" ];

  postPatch = ''
    sed -E -i -e 's|/bin/pwd|${buildPackages.coreutils}/bin/pwd|' $BSDSRCDIR/stand/defs.mk
    #sed -E -i -e 's|-e start|-Wl,-e,start|g' $BSDSRCDIR/stand/i386/Makefile.inc $BSDSRCDIR/stand/i386/*/Makefile
  '';
}
