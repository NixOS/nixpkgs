{ mkDerivation }:
mkDerivation {
  path = "usr.bin/vmstat";

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/usr.bin/vmstat/Makefile
  '';
}
