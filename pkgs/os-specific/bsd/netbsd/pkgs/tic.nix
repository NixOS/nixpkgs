{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  nbperf,
  rsync,
  compatIfNeeded,
  defaultMakeFlags,
  libterminfo,
}:

mkDerivation {
  path = "tools/tic";
  HOSTPROG = "tic";
  buildInputs = compatIfNeeded;
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    nbperf
    rsync
  ];
  makeFlags = defaultMakeFlags ++ [ "TOOLDIR=$(out)" ];
  extraPaths = [
    libterminfo.path
    "usr.bin/tic"
    "tools/Makefile.host"
  ];
}
