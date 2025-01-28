{ mkDerivation, libkvm }:
mkDerivation {
  path = "bin/ps";

  buildInputs = [ libkvm ];
  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/bin/ps/Makefile
  '';
}
