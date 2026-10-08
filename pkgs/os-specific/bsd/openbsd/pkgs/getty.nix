{
  mkDerivation,
  login,
}:
mkDerivation {
  path = "libexec/getty";
  extraPaths = [ "etc/gettytab" ];

  postPatch = ''
    substituteInPlace $BSDSRCDIR/libexec/getty/pathnames.h \
        --replace-fail "/usr/libexec/getty" "$out/bin/getty" \
        --replace-fail "/usr/bin/login" "${login}/bin/login"
  '';

  postInstall = ''
    mkdir -p $out/etc
    cp $BSDSRCDIR/etc/gettytab $out/etc/gettytab
  '';

  meta.mainProgram = "getty";
}
