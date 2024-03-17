{ stdenv, mkDerivation, buildPackages, buildFreebsd, ... }:
mkDerivation {
  path = "usr.bin/mkcsmapper";

  extraPaths = [ "lib/libc/iconv" "lib/libiconv_modules/mapper_std" ];

  BOOTSTRAPPING = !stdenv.hostPlatform.isFreeBSD;

  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook

    buildPackages.byacc
    buildPackages.flex
  ];
}
