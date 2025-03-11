{
  mkDerivation,
  libevent,
  byacc,
}:
mkDerivation {
  path = "sbin/slaacd";

  postPatch = ''
    sed -i 's/DPADD/#DPADD/' $BSDSRCDIR/sbin/slaacd/Makefile
  '';

  buildInputs = [ libevent ];
  extraNativeBuildInputs = [ byacc ];
}
