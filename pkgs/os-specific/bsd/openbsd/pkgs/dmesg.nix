{ mkDerivation }:
mkDerivation {
  path = "sbin/dmesg";

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/sbin/dmesg/Makefile
  '';
}
