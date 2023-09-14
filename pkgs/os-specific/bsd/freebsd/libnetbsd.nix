{ mkDerivation, buildPackages, stdenv, lib, compatIfNeeded, pkgs }:
mkDerivation {
  path = "lib/libnetbsd";
  nativeBuildInputs = with buildPackages.freebsd; [
    pkgs.bsdSetupHook freebsdSetupHook
    makeMinimal pkgs.mandoc pkgs.groff
    (if stdenv.hostPlatform == stdenv.buildPlatform
     then boot-install
     else install)
  ];
  patches = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
    ./libnetbsd-do-install.patch
    #./libnetbsd-define-__va_list.patch
  ];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
  buildInputs = compatIfNeeded;
}
