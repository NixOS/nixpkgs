{ stdenv, mkDerivation, buildPackages, buildFreebsd, ... }:
mkDerivation {
  path = "usr.bin/mkesdb";

  extraPaths = [ "lib/libc/iconv" ];

  BOOTSTRAPPING = !stdenv.hostPlatform.isFreeBSD;

  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook

    buildPackages.byacc
    buildPackages.flex
  ];
}
