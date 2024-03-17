{
  mkKdeDerivation,
  knewstuff,
  kdeclarative,
  plasma-workspace,
}:
mkKdeDerivation {
  pname = "systemsettings";
  extraBuildInputs = [
    knewstuff
    kdeclarative
    plasma-workspace
  ];
}
