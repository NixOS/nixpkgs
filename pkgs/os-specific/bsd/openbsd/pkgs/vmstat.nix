{ mkDerivation, libkvm }:
mkDerivation {
  path = "usr.bin/vmstat";

  buildInputs = [ libkvm ];
  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/usr.bin/vmstat/Makefile
  '';
}
