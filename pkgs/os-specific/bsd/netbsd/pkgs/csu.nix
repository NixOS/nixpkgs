{
  lib,
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  flex,
  byacc,
  genassym,
  gencat,
  lorder,
  tsort,
  statHook,
  headers,
  sys-headers,
  ld_elf_so,
}:

mkDerivation {
  noLibc = true;
  path = "lib/csu";
  meta.platforms = lib.platforms.netbsd;
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    flex
    byacc
    genassym
    gencat
    lorder
    tsort
    statHook
  ];
  buildInputs = [ headers ];
  extraPaths = [
    sys-headers.path
    ld_elf_so.path
  ];
}
