{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  nbperf,
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
  ];
  makeFlags = defaultMakeFlags ++ [ "TOOLDIR=$(out)" ];
  extraPaths = [
    libterminfo.path
    "usr.bin/tic"
    "tools/Makefile.host"
  ];
}
