{
  mkKdeDerivation,
  kauth,
}:
mkKdeDerivation {
  pname = "systemsettings";

  extraBuildInputs = [ kauth ];

  meta.mainProgram = "systemsettings";
}
