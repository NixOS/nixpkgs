{
  mkDerivation,
  libc,
  sys,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  byacc,
  install,
  tsort,
  lorder,
  mandoc,
  statHook,
  rsync,
  headers,
}:

mkDerivation {
  path = "lib/libutil";
  extraPaths = [
    "common"
    "lib/libc"
    "sys"
  ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    byacc
    install
    tsort
    lorder
    mandoc
    statHook
    rsync
  ];
  buildInputs = [ headers ];
  SHLIBINSTALLDIR = "$(out)/lib";
}
