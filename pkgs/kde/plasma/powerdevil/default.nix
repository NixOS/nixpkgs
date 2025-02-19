{
  mkKdeDerivation,
  pkg-config,
  ddcutil,
  qtwayland,
}:
mkKdeDerivation {
  pname = "powerdevil";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    ddcutil
    qtwayland
  ];
}
