{ mkDerivation, buildPackages, buildFreebsd, stdenv, lib, ... }:
mkDerivation {
  path = "lib/libnetbsd";
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.makeMinimal buildPackages.mandoc buildPackages.groff  # TODO bmake???
    (if stdenv.hostPlatform == stdenv.buildPlatform
     then buildFreebsd.boot-install
     else buildFreebsd.install)
  ];
  patches = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
    ./libnetbsd-do-install.patch
    #./libnetbsd-define-__va_list.patch
  ];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
}
