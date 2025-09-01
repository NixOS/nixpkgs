{
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/pkill";

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/usr.bin/pkill/Makefile
  '';
}
