{
  mkDerivation,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  flex,
  byacc,
  file2c,
  compatIfNeeded,
  libnv,
  libsbuf,
}:

mkDerivation {
  path = "usr.sbin/config";
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    install
    mandoc
    groff

    flex
    byacc
    file2c
  ];
  buildInputs = compatIfNeeded ++ [
    libnv
    libsbuf
  ];
}
