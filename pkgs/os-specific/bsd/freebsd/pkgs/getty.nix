{
  mkDerivation,
  login,
  useWrappedLogin ? true,
}:
mkDerivation {
  path = "libexec/getty";

  postPatch = ''
    sed -E -i -e "s|/usr/bin/login|${
      if useWrappedLogin then "/run/wrappers/bin/login" else "${login}/bin/login"
    }|g" $BSDSRCDIR/libexec/getty/*.h
  '';

  MK_TESTS = "no";

  postInstall = ''
    mkdir -p $out/etc
    cp $BSDSRCDIR/libexec/getty/gettytab $out/etc/gettytab
  '';
}
