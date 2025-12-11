{
  lib,
  makeSetupHook,
  mkAppleDerivation,
  stdenv,
}:

mkAppleDerivation {
  releaseName = "Csu";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}clang"
    "CHMOD=chmod"
    "MKDIR=mkdir"
    "USRLIBDIR=/lib"
    "LOCLIBDIR=/lib"
  ];

  installFlags = [ "DSTROOT=$(out)" ];

  setupHooks = [
    ../../../../build-support/setup-hooks/role.bash
    # ccWrapper_addCVars doesn’t add Csu to `NIX_LDFLAGS` because it contains objects and no dylibs.
    ./setup-hooks/add-Csu-lib-path.sh
  ];

  meta = {
    description = "Common startup stubs for Darwin";
    badPlatforms = [ lib.systems.inspect.patterns.isAarch ];
  };
}
