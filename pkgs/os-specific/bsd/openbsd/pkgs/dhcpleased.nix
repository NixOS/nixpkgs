{
  mkDerivation,
  libevent,
  byacc,
}:
mkDerivation {
  path = "sbin/dhcpleased";

  postPatch = ''
    sed -i 's/DPADD/#DPADD/' $BSDSRCDIR/sbin/dhcpleased/Makefile
  '';

  buildInputs = [ libevent ];
  extraNativeBuildInputs = [ byacc ];
}
