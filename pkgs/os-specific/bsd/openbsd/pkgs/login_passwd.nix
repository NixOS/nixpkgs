{
  mkDerivation,
}:
mkDerivation {
  path = "libexec/login_passwd";

  postPatch = ''
    sed -i 's/4555/0555/' $BSDSRCDIR/libexec/login_passwd/Makefile
  '';
}
