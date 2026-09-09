{ mkDerivation }:
mkDerivation {
  path = "bin/ps";

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/bin/ps/Makefile
  '';
}
