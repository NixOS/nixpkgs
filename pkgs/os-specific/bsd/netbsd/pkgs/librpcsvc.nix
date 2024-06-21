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
  makeFlags = defaultMakeFlags ++ [ "INCSDIR=$(out)/include/rpcsvc" ];
  meta.platforms = lib.platforms.netbsd;
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
}
