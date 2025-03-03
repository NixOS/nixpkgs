{
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/su";

  postPatch = ''
    sed -i /BINMODE/d $BSDSRCDIR/usr.bin/su/Makefile
  '';

  meta.mainProgram = "su";
}
