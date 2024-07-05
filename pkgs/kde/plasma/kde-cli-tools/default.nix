{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kde-cli-tools";

  extraBuildInputs = [qtsvg];

  postInstall = ''
    # install a symlink in bin so that kdesu can eventually be found in PATH
    mkdir -p $out/bin
    ln -s $out/libexec/kf6/kdesu $out/bin/
  '';
}
