{
  mkKdeDerivation,
  pkg-config,
  kidletime,
  networkmanager-qt,
  plasma-activities,
  gpsd,
}:
mkKdeDerivation {
  pname = "plasma5support";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    kidletime
    networkmanager-qt
    plasma-activities

    gpsd
  ];
}
