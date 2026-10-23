{
  lib,
  mkDerivation,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  rpcgen,
  statHook,
}:

mkDerivation {
  path = "lib/librpcsvc";

  libcMinimal = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    rpcgen
    statHook
  ];

  makeFlags = [ "INCSDIR=$(dev)/include/rpcsvc" ];

  meta.platforms = lib.platforms.openbsd;
}
