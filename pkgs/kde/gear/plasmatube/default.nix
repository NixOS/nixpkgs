{
  mkKdeDerivation,
  qtquick3d,
  qtsvg,
  purpose,
  pkg-config,
  mpv,
}:
mkKdeDerivation {
  pname = "plasmatube";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtquick3d qtsvg mpv];
  extraPropagatedBuildInputs = [purpose];
}
