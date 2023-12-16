{ mkDerivation, buildFreebsd, buildPackages, compatIfNeeded, libnv, libsbuf, lib, stdenv, ...}:
mkDerivation {
  path = "usr.sbin/config";
  nativeBuildInputs = (with buildPackages; [
    bsdSetupHook
    flex byacc mandoc groff
  ]) ++ (with buildFreebsd; [
    freebsdSetupHook
    bmakeMinimal install
    file2c
  ]);
  buildInputs = compatIfNeeded ++ [ libnv libsbuf ];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "RELDIR=."
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";
}
