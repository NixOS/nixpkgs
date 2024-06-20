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
    libc.path
    sys.path
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
