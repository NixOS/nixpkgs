{
  mkDerivation,
  libkvm,
}:
mkDerivation {
  path = "usr.bin/pkill";

  buildInputs = [
    libkvm
  ];

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/usr.bin/pkill/Makefile
  '';
}
