{
  mkDerivation,
  libelf,
  compatIfNeeded,
}:
mkDerivation {
  path = "usr.sbin/kldxref";

  buildInputs = [ libelf ] ++ compatIfNeeded;

  # We symlink in our modules, make it follow symlinks
  postPatch = ''
    sed -i 's/FTS_PHYSICAL/FTS_LOGICAL/' $BSDSRCDIR/usr.sbin/kldxref/kldxref.c
  '';
}
