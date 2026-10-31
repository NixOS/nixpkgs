{
  mkKdeDerivation,
  pam,
  qqc2-breeze-style,
}:
mkKdeDerivation {
  pname = "kscreenlocker";

  extraBuildInputs = [
    pam
    qqc2-breeze-style
  ];
}
