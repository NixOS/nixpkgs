{ mkDerivation, libkvm }:
mkDerivation {
  path = "sbin/dmesg";

  buildInputs = [ libkvm ];

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/sbin/dmesg/Makefile
  '';
}
