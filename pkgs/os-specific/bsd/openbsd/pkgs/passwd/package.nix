{
  lib,
  mkDerivation,
  librpcsvc,
  libutil,
}:
mkDerivation {
  path = "usr.bin/passwd";
  extraPaths = [ "usr.bin/chpass" ];
  buildInputs = [
    librpcsvc
    libutil
  ];

  # The system supplies setuid wrappers and pwd_mkdb is packaged separately.
  postPatch = ''
    sed -i -e '/^BINMODE=/d' -e '/^DPADD/d' $BSDSRCDIR/usr.bin/passwd/Makefile
  '';

  meta = {
    description = "OpenBSD password-changing utility";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "passwd";
    platforms = lib.platforms.openbsd;
  };
}
