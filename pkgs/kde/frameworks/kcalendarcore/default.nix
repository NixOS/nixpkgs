{
  mkKdeDerivation,
  libical,
}:
mkKdeDerivation {
  pname = "kcalendarcore";

  extraBuildInputs = [libical];
}
