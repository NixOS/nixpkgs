{
  lib,
  mkDerivation,
  libpam,
  libbsm,
}:
mkDerivation {
  path = "usr.bin/su";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  buildInputs = [
    libpam
    libbsm
  ];

  postPatch = ''
    sed -E -i -e '/BINOWN|BINMODE|PRECIOUSPROG/d' $BSDSRCDIR/usr.bin/su/Makefile
  '';

  meta.mainProgram = "su";
  meta.platforms = lib.platforms.freebsd;
}
