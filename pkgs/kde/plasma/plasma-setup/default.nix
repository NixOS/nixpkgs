{
  mkKdeDerivation,
  pkg-config,
  qtlocation,
  plasma-nm,
}:
mkKdeDerivation {
  pname = "plasma-setup";

  patches = [ ./optional-dependencies.patch ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtlocation
    plasma-nm
  ];
}
