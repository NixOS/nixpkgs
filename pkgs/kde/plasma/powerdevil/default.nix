{
  mkKdeDerivation,
  pkg-config,
  libcap,
  ddcutil,
}:
mkKdeDerivation {
  pname = "powerdevil";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [libcap ddcutil];
}
