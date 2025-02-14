{
  lib,
  mkDerivation,
  defaultMakeFlags,
  bsdSetupHook,
  netbsdSetupHook,
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
    netbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    rpcgen
    statHook
  ];

  makeFlags = defaultMakeFlags ++ [ "INCSDIR=$(dev)/include/rpcsvc" ];

  meta.platforms = lib.platforms.netbsd;
}
