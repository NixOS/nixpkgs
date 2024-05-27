{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  byacc,
  flex,
  rsync,
  compatIfNeeded,
  cksum,
}:
mkDerivation {
  path = "usr.bin/config";
  version = "9.2";
  sha256 = "1yz3n4hncdkk6kp595fh2q5lg150vpqg8iw2dccydkyw4y3hgsjj";
  env.NIX_CFLAGS_COMPILE = toString [ "-DMAKE_BOOTSTRAP" ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    byacc
    flex
    rsync
  ];
  buildInputs = compatIfNeeded;
  extraPaths = [ cksum.src ];
}
