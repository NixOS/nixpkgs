{
  mkDerivation,
  common,
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
  version = "9.2";
  sha256 = "02gm5a5zhh8qp5r5q5r7x8x6x50ir1i0ncgsnfwh1vnrz6mxbq7z";
  extraPaths = [
    common
    libc.src
    sys.src
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
