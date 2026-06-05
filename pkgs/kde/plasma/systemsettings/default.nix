{
  mkKdeDerivation,
}:
mkKdeDerivation {
  pname = "systemsettings";
  outputs = [
    "out"
    "doc"
  ];
  meta.mainProgram = "systemsettings";
}
