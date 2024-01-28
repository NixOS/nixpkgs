{ mkDerivation, lib, stdenv, libutil, libpam, libbsm, buildFreebsd, buildPackages, ... }:
mkDerivation {
  path = "usr.bin/login";
  buildInputs = [libutil libpam libbsm];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook
    buildFreebsd.cap_mkdb
  ];

  postPatch = ''
    sed -E -i -e "s|..DESTDIR./etc|\''${CONFDIR}|g" $BSDSRCDIR/usr.bin/login/Makefile
  '';

  clangFixup = true;

  MK_TESTS = "no";
  MK_SETUID_LOGIN = "no";

  postInstall = ''
    mkdir -p $out/etc
    make $makeFlags installconfig
  '';
}
