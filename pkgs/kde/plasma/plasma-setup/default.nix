{
  mkKdeDerivation,
  pkg-config,
  qtlocation,
  plasma-nm,
}:
mkKdeDerivation {
  pname = "plasma-setup";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtlocation
    plasma-nm
  ];
}
