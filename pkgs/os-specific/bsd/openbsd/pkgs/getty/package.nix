{
  mkDerivation,
  login,
}:
mkDerivation {
  path = "libexec/getty";

  postPatch = ''
    substituteInPlace $BSDSRCDIR/libexec/getty/pathnames.h \
        --replace-fail "/usr/libexec/getty" "$out/bin/getty" \
        --replace-fail "/usr/bin/login" "${login}/bin/login"
  '';
}
