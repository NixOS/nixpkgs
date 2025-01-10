{
  mkKdeDerivation,
  pam,
  wayland,
  qqc2-breeze-style,
}:
mkKdeDerivation {
  pname = "kscreenlocker";

  extraNativeBuildInputs = [wayland];
  extraBuildInputs = [pam qqc2-breeze-style];
}
