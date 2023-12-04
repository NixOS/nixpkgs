{ mkDerivation, ...}:
mkDerivation {
  pname = "utils";
  path = "bin";
  extraPaths = ["sbin" "usr.bin" "usr.sbin"];

  postBuild = ''
    make -C $BSDSRCDIR/sbin $makeFlags
    make -C $BSDSRCDIR/usr.bin $makeFlags
    make -C $BSDSRCDIR/usr.sbin $makeFlags
  '';

  postInstall = ''
    make -C $BSDSRCDIR/sbin $makeFlags install
    make -C $BSDSRCDIR/usr.bin $makeFlags install
    make -C $BSDSRCDIR/usr.sbin $makeFlags install
  '';
}
