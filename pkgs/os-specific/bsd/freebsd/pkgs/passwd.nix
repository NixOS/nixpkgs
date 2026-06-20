{
  lib,
  mkDerivation,
  libpam,
}:
mkDerivation {
  path = "usr.bin/passwd";

  buildInputs = [
    libpam
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  postPatch = ''
    sed -E -i -e '/BINOWN|BINMODE|PRECIOUSPROG/d' $BSDSRCDIR/usr.bin/passwd/Makefile
  '';

  meta.platforms = lib.platforms.freebsd;
  meta.mainProgram = "passwd";
}
