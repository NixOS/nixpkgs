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
  rsync,
  headers,
  sys,
  ld_elf_so,
}:

mkDerivation {
  path = "lib/csu";
  version = "9.2";
  sha256 = "0al5jfazvhlzn9hvmnrbchx4d0gm282hq5gp4xs2zmj9ycmf6d03";
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
    rsync
  ];
  buildInputs = [ headers ];
  extraPaths = [
    sys.src
    ld_elf_so.src
  ];
}
