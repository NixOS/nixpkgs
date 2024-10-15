{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
}:
mkKdeDerivation {
  pname = "powerdevil";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtwayland ];
}
