{
  mkKdeDerivation,
  pam,
  wayland-scanner,
  qqc2-breeze-style,
}:
mkKdeDerivation {
  pname = "kscreenlocker";

  extraNativeBuildInputs = [wayland-scanner];
  extraBuildInputs = [pam qqc2-breeze-style];
}
