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
  version = "9.2";
  sha256 = "1q34pfiyjbrgrdqm46jwrsqms49ly6z3b0xh1wg331zga900vq5n";
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
